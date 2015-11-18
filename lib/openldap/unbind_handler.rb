require 'openldap/bindings'
module OpenLDAP
  # Unbinds from LDAP server in case the user forgot to do this, themselves.
  class UnbindHandler
    include OpenLDAP::Bindings
    def initialize(handles)
      @pid = $$
      @handles = handles
    end

    def call(*args)
      # Don't clean up handles we don't own (like if we forked)
      return if @pid != $$

      @handles.each do |h|
        next if h.nil?
        ldap_unbind_s(h)
      end

      @handles.clear
    end
  end
end

