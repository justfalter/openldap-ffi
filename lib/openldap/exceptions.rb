require 'openldap/constants'
require 'openldap/bindings'

module OpenLDAP
  class LDAPError < StandardError
    attr_reader :result_code
    def initialize(result_code)
      @result_code = result_code
      message = OpenLDAP::Bindings::ldap_err2string(@result_code)
      super(message)
    end
  end

  class LDAPAttributeError < LDAPError; end
  class LDAPNameError < LDAPError; end
  class LDAPSecurityError < LDAPError; end
  class LDAPServiceError < LDAPError; end
  class LDAPUpdateError < LDAPError; end
  class LDAPExperimentalError < LDAPError; end
  class LDAPPrivateError < LDAPError; end
  class LDAPOtherError < LDAPError; end

  module Exceptions
    include OpenLDAP::Constants
    # Raises the appropriate exception class based on the result code.
    def self.result_code_type(rc)
      case rc
      when LDAP_SUCCESS then :success
      when 0x10..0x15 then :attr_error
      when 0x20..0x24 then :name_error
      when 0x2F..0x24 then :security_error
      when 0x33..0x36 then :service_error
      when 0x40..0x47 then :update_error
      when 0x1000..0x3FFF then :experimental_error
      when 0x4000..0xFFFF then :private_error
      else
        :other
      end
    end

    def self.build_ldap_exception(result_code)
      error_klass = case result_code_type(result_code)
                    when :success then nil
                    when :attr_error then LDAPAttributeError
                    when :name_error then LDAPNameError
                    when :security_error then LDAPSecurityError
                    when :service_error then LDAPServiceError
                    when :update_error then LDAPUpdateError
                    when :experimental_error then LDAPExperimentalError
                    when :private_error then LDAPPrivateError
                    else
                      LDAPOtherError
                    end
      if error_klass.nil?
        return nil
      end
      error_klass.new(result_code)
    end
  end
end
