require 'ffi'
require 'ffi/libc'

module OpenLDAP
  class SearchRequest
    attr_accessor :basedn, :filter, :attributes, :tout
    attr_reader :scope
    # @param [String] basedn The base distinguished name to search
    # @param [Hash] opts Options
    # @option opts [Symbol] :scope (:subtree) Search scope. Allowed values: :base, :onelevel, 
    #   :subtree, :subordinate, :default.
    # @option opts [String] :filter (nil)
    # @option opts [String] :attributes ("*") Space separated list of attributes to return.
    # @option opts [Integer] :timeout (10) The number of seconds to wait before giving up on the query.
    def initialize(basedn, opts = {})
      o = {
        scope: :subtree,
        filter: nil,
        attributes: "*",
        timeout: 10
      }.merge(opts)

      self.basedn     = basedn
      self.filter     = o[:filter]
      self.attributes = o[:attributes]
      self.tout       = o[:timeout]
    end

    def attributes_pointer
      attr_strings = @attributes.split(/\s+/)
      attrs = FFI::MemoryPointer.new(:pointer, attr_strings.count + 1)
      attrs[attr_strings.count].put_pointer(0,nil)
      attr_strings.each_with_index do |str, i|
        attrs[i].put_pointer(0, FFI::MemoryPointer.from_string(str))
      end
      attrs
    end

    def scope=(v)
      scope_v = LDAP_SCOPE_MAP[v]
      if scope_v.nil?
        raise ArgumentError.new("Invalid scope value: #{v}")
      end
      @scope = v
    end

    def scope_value
      return LDAP_SCOPE_MAP[v]
    end
  end
end
