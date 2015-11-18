require 'openldap/bindings'
require 'openldap/constants'
require 'openldap/exceptions'
require 'openldap/entry'
require 'openldap/unbind_handler'
require 'ffi/libc'
require 'uri'

module OpenLDAP
  class Connection
    include OpenLDAP::Bindings
    include OpenLDAP::Constants
    include OpenLDAP::Exceptions

    # @param [String] url A valid LDAP URL
    # @param [Hash] opts Options
    # @option opts :tls_require_cert (see #tls_require_cert=)
    def initialize(url, opts = {})
      uri = URI(url)

      unless uri.kind_of?(URI::LDAP)
        raise ArgumentError.new("Not a LDAP URI: #{url}")
      end
      handle_ptr = FFI::MemoryPointer.new(:pointer)
      res = ldap_initialize(handle_ptr, url)
      raise_if_error!(res)
      @handle = handle_ptr.get_pointer(0)
      if @handle.null?
        #:nocov:
        raise "ldap_initialize failed: #{url}"
        #:nocov:
      end

      @handles_for_cleanup = [ @handle ]
      ObjectSpace.define_finalizer(self, UnbindHandler.new(@handles_for_cleanup))

      unless opts[:tls_require_cert].nil?
        self.tls_require_cert = opts[:tls_require_cert]
      end
    end

    # @param [:never,:hard,:demand,:allow,:try] v Set the type of certificate 
    #   validation that will be required. 
    # @raise ArgumentError if v is unknown
    def tls_require_cert=(v)
      new_v = LDAP_OPT_X_TLS_REQUIRE_CERT_MAP[v]
      if new_v.nil?
        raise ArgumentError.new "Unknown value: #{v}"
      end
      v_ptr = FFI::MemoryPointer.new(:int)
      v_ptr.write_int(new_v)
      res = ldap_set_option(@handle, LDAP_OPT_X_TLS_REQUIRE_CERT, v_ptr)
      raise_if_error!(res)
      v_ptr.write_int(0)
      # Recreate TLS context. Per: http://www.openldap.org/lists/openldap-technical/201202/msg00463.html
      res = ldap_set_option(@handle, LDAP_OPT_X_TLS_NEWCTX, v_ptr)
      raise_if_error!(res)
      v
    end

    def tls_require_cert
      v_ptr = FFI::MemoryPointer.new(:int)
      res = ldap_get_option(@handle, LDAP_OPT_X_TLS_REQUIRE_CERT,v_ptr)
      raise_if_error!(res)
      int_v = v_ptr.read_int()

      k,_ = LDAP_OPT_X_TLS_REQUIRE_CERT_MAP.find {|k,v| v == int_v}

      k
    end

    # @param [Integer] rc The result code
    # @raise OpenLDAP::LDAPError if there are any errors.
    def raise_if_error!(rc)
      return if rc == LDAP_SUCCESS
      e = OpenLDAP::Exceptions.build_ldap_exception(rc)
      raise e unless e.nil?
    end

    def bind_simple(username, password)
      rc = ldap_simple_bind_s(@handle, username, password)
      raise_if_error!(rc)
    end

    # @param [String] basedn The base distinguished name to search
    # @param [Hash] opts Options
    # @option opts [Symbol] :scope (:subtree) Search scope. Allowed values: :base, :onelevel, 
    #   :subtree, :subordinate, :default.
    # @option opts [String] :filter (nil)
    # @option opts [String] :attributes ("*") Space separated list of attributes to return.
    # @option opts [Integer] :timeout (10) The number of seconds to wait before giving up on the query.
    def search(basedn, opts = {}, &block)
      o = {
        scope: :subtree,
        filter: nil,
        attributes: "*",
        timeout: 10
      }.merge(opts)

      attr_strings = o[:attributes].split(/\s+/)
      attrs = FFI::MemoryPointer.new(:pointer, attr_strings.count + 1)
      attrs[attr_strings.count].put_pointer(0,nil)
      attr_strings.each_with_index do |str, i|
        attrs[i].put_pointer(0, FFI::MemoryPointer.from_string(str))
      end

      res_ptrptr = FFI::MemoryPointer.new(:pointer)

      scope_v = LDAP_SCOPE_MAP[o[:scope]]
      if scope_v.nil?
        raise ArgumentError.new("Invalid scope value: #{o[:scope]}")
      end

      tout = FFI::LibC::Timeval.new
      tout[:tv_sec] = o[:timeout]

      rc = nil
      rc = ldap_search_ext(
        @handle, 
        basedn,
        scope_v,
        o[:filter],
        attrs,
        0, 
        nil,
        nil,
        tout,
        0,
        res_ptrptr)

      raise_if_error!(rc)

      tout2 = FFI::LibC::Timeval.new
      tout2[:tv_sec] = o[:timeout]

      res2 = FFI::MemoryPointer.new(:pointer)

      keep_going = true
      loop_count = 0
      msg_count  = 0
      while keep_going == true &&
            (rc = ldap_result(@handle, LDAP_RES_ANY, LDAP_MSG_ONE, tout2, res2)) > 0
        msg = ldap_first_message(@handle, res2.get_pointer(0))
        while !msg.null?
          msgtype = ldap_msgtype(msg)
          case msgtype
          when LDAP_RES_SEARCH_ENTRY
            #puts "#{loop_count} #{msg_count}: search_entry"
            _iterate_search_response(msg, &block)
          when LDAP_RES_SEARCH_REFERENCE
            #puts "#{loop_count} #{msg_count}: search_reference"
          when LDAP_RES_EXTENDED
            #puts "#{loop_count} #{msg_count}: extended"
          when LDAP_RES_SEARCH_RESULT
            # This means we're done.
            #puts "#{loop_count} #{msg_count}: search_result"
            keep_going = false
            break
          when LDAP_RES_INTERMEDIATE
            #puts "#{loop_count} #{msg_count}: intermediate"
          else
            #puts "#{loop_count} #{msg_count}: unknown: #{msgtype}"
          end

          msg_count+=1
          msg = ldap_next_message(@handle, msg)
        end
        loop_count += 1
      end
      ldap_msgfree(res2.get_pointer(0))
    end

    def _iterate_search_response(msg, &block)
      e = ldap_first_entry(@handle,msg)
      while !e.null?
        entry = _parse_entry(e)
        yield(entry)
        e = ldap_next_entry(@handle, e) 
      end
    end

    def _parse_entry(e)
      dn = ldap_get_dn(@handle, e)
      entry = Entry.new(dn)

      berptrptr = FFI::MemoryPointer.new(:pointer)
      name = ldap_first_attribute(@handle, e, berptrptr)
      berptr = berptrptr.get_pointer(0)

      while !name.nil?
        val_ptr = ldap_get_values(@handle, e, name)
        vals = val_ptr.get_array_of_string(0)
        entry[name] = vals
        ldap_value_free(val_ptr)
        name = ldap_next_attribute(@handle, e, berptr)
      end

      ber_free(berptr, 0)
      entry
    end

    def unbind
      return if @handle.nil?
      ldap_unbind_s(@handle)
      @handle = nil
      @handles_for_cleanup.clear
      ObjectSpace.undefine_finalizer(self)
      nil
    end

  end
end
