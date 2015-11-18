require 'spec_helper'
require 'openldap/unbind_handler'

describe OpenLDAP::UnbindHandler do
  describe "#call" do
    it "should call ldap_unbind_s for each handle in the array" do
      handle1 = double("ldap handle 1")
      handle2 = double("ldap handle 2")
      handles = [handle1, handle2]
      uh = OpenLDAP::UnbindHandler.new(handles)

      expect(uh).to receive(:ldap_unbind_s).with(handle1)
      expect(uh).to receive(:ldap_unbind_s).with(handle2)

      uh.call
    end

    it "should clear the array of handles" do
      handles = []
      uh = OpenLDAP::UnbindHandler.new(handles)

      expect(handles).to receive(:clear)
      uh.call
    end
  end
end
