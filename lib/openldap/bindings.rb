require 'ffi'
require 'ffi/libc'
module OpenLDAP
  module Structs
  end

  module Bindings
    extend FFI::Library

    LIBNAMES = ['libldap-2.4', 'libldap-2.4.so', 'libldap-2.4.so.2']
    if ENV['LIBLDAP']
      # :nocov:
      LIBNAMES.unshift(ENV['LIBLDAP'])
      # :nocov:
    end

    ffi_lib LIBNAMES

    typedef :pointer, :ldap_ptr # Opaque
    typedef :pointer, :LDAPMessage_ptr # Opaque
    typedef :pointer, :BerElement_ptr # Opaque

    typedef :long, :lber_len_t
    typedef :lber_len_t, :ber_len_t

    class Berval < FFI::Struct
      layout :bv_len, :lber_len_t,
             :bv_val, :string
    end

    class LDAPControl < FFI::Struct
      layout :ldctl_oid, :string,
             :ldctl_value, Berval,
             :ldctl_iscritical, :char
    end

    attach_function :ldap_init, [:string, :int], :ldap_ptr
    attach_function :ldap_open, [:string, :int], :ldap_ptr
    attach_function :ldap_initialize, [:pointer, :string], :int

    attach_function :ldap_bind, [:ldap_ptr, :string, :string, :int], :int
    attach_function :ldap_bind_s, [:ldap_ptr, :string, :string, :int], :int
    attach_function :ldap_simple_bind, [:ldap_ptr, :string, :string], :int
    attach_function :ldap_simple_bind_s, [:ldap_ptr, :string, :string], :int

    attach_function :ldap_unbind, [:ldap_ptr], :int
    attach_function :ldap_unbind_s, [:ldap_ptr], :int

    attach_function :ldap_err2string, [:int], :string

    # int ldap_result( LDAP *ld, int msgid, int all, struct timeval *timeout, LDAPMessage **result );
    attach_function :ldap_result, [:ldap_ptr, :int, :int, FFI::LibC::Timeval.by_ref, :pointer], :int
    #int ldap_msgfree( LDAPMessage *msg );
    attach_function :ldap_msgfree, [:LDAPMessage_ptr], :int

    #int ldap_msgtype( LDAPMessage *msg );
    attach_function :ldap_msgtype, [:LDAPMessage_ptr], :int

    #int ldap_msgid( LDAPMessage *msg );
    attach_function :ldap_msgid, [:LDAPMessage_ptr], :int

    attach_function :ldap_search, [:ldap_ptr, :string, :int, :string, :pointer, :int], :int
    attach_function :ldap_search_s, [:ldap_ptr, :string, :int, :string, :pointer, :int, :pointer], :int
    attach_function :ldap_search_st, [:ldap_ptr, :string, :int, :string, :pointer, :int, FFI::LibC::Timeval.by_ref, :pointer], :int

    # int ldap_search_ext(
    #       LDAP *ld,
    #       char *base,
    #       int scope,
    #       char *filter,
    #       char *attrs[],
    #       int attrsonly,
    #       LDAPControl **serverctrls,
    #       LDAPControl **clientctrls,
    #       struct timeval *timeout,
    #       int sizelimit,
    #       int *msgidp );
    attach_function :ldap_search_ext, [
      :ldap_ptr,                  # LDAP *ld
      :string,                    # char *base
      :int,                       # int scope
      :string,                    # char *filter
      :pointer,                   # char *attrs[]
      :int,                       # int attrsonly
      :pointer,                   # LDAPControl **serverctrls
      :pointer,                   # LDAPControl **clientctrls
      FFI::LibC::Timeval.by_ref,  # struct timeval *timeout
      :int,                       # int sizelimit
      :pointer                    # int *msgidp
    ], :int

    # int ldap_search_ext_s(
    #       LDAP *ld,
    #       char *base,
    #       int scope,
    #       char *filter,
    #       char *attrs[],
    #       int attrsonly,
    #       LDAPControl **serverctrls,
    #       LDAPControl **clientctrls,
    #       struct timeval *timeout,
    #       int sizelimit,
    #       LDAPMessage **res );

    attach_function :ldap_search_ext_s, [
      :ldap_ptr,                  # LDAP *ld,
      :string,                    # char *base,
      :int,                       # int scope,
      :string,                    # char *filter,
      :pointer,                   # char *attrs[],
      :int,                       # int attrsonly,
      :pointer,                   # LDAPControl **serverctrls,
      :pointer,                   # LDAPControl **clientctrls,
      FFI::LibC::Timeval.by_ref,  # struct timeval *timeout,
      :int,                       # int sizelimit,
      :pointer                    # LDAPMessage **res
    ], :int

    # char *ldap_get_dn( LDAP *ld, LDAPMessage *entry )
    attach_function :ldap_get_dn, [:ldap_ptr, :LDAPMessage_ptr], :string

    # int ldap_count_entries( LDAP *ld, LDAPMessage *result )
    attach_function :ldap_count_entries, [:ldap_ptr, :LDAPMessage_ptr], :int

    # LDAPMessage *ldap_first_entry( LDAP *ld, LDAPMessage *result )
    attach_function :ldap_first_entry, [:ldap_ptr, :LDAPMessage_ptr], :LDAPMessage_ptr

    # LDAPMessage *ldap_next_entry( LDAP *ld, LDAPMessage *entry )
    attach_function :ldap_next_entry, [:ldap_ptr, :LDAPMessage_ptr], :LDAPMessage_ptr

    # char *ldap_first_attribute(LDAP *ld, LDAPMessage *entry, BerElement **berptr )
    attach_function :ldap_first_attribute, [:ldap_ptr, :LDAPMessage_ptr, :pointer], :string

    # char *ldap_next_attribute(LDAP *ld, LDAPMessage *entry, BerElement *ber )
    attach_function :ldap_next_attribute, [:ldap_ptr, :LDAPMessage_ptr, :BerElement_ptr], :string

    # char **ldap_get_values(LDAP *ld, LDAPMessage *entry, char *attr)
    attach_function :ldap_get_values, [:ldap_ptr, :LDAPMessage_ptr, :string], :pointer

    # struct berval **ldap_get_values_len(LDAP *ld, LDAPMessage *entry, char *attr)
    attach_function :ldap_get_values_len, [:ldap_ptr, :LDAPMessage_ptr, :string], :pointer

    # int ldap_count_values(char **vals)
    attach_function :ldap_count_values, [:pointer], :int

    # int ldap_count_values_len(struct berval **vals)
    attach_function :ldap_count_values_len, [:pointer], :int

    # void ldap_value_free(char **vals)
    attach_function :ldap_value_free, [:pointer], :void

    # void ldap_value_free_len(struct berval **vals)
    attach_function :ldap_value_free_len, [:pointer], :void

    # void ber_free(BerElement *ber, int freebuf)
    attach_function :ber_free, [:BerElement_ptr, :int], :void


    #int ldap_count_messages( LDAP *ld, LDAPMessage *result )
    attach_function :ldap_count_messages, [:ldap_ptr, :LDAPMessage_ptr], :int

    #LDAPMessage *ldap_first_message( LDAP *ld, LDAPMessage *result )
    attach_function :ldap_first_message, [:ldap_ptr, :LDAPMessage_ptr], :LDAPMessage_ptr

    #LDAPMessage *ldap_next_message( LDAP *ld, LDAPMessage *message )
    attach_function :ldap_next_message, [:ldap_ptr, :LDAPMessage_ptr], :LDAPMessage_ptr

    # int ldap_get_option(LDAP *ld, int option, void *outvalue);
    attach_function :ldap_get_option, [:ldap_ptr, :int, :pointer], :int

    # int ldap_set_option(LDAP *ld, int option, const void *invalue);
    attach_function :ldap_set_option, [:ldap_ptr, :int, :pointer], :int
  end
end
