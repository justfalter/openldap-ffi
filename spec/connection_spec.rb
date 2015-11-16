require 'spec_helper'
require 'openldap/connection'


describe OpenLDAP::Connection do
  describe ".new" do
    it "should raise an ArgumentError if the string is not an LDAP url" do
      expect {
        OpenLDAP::Connection.new("http://foo.com")
      }.to raise_error(ArgumentError)
      expect {
        OpenLDAP::Connection.new("foo.com")
      }.to raise_error(ArgumentError)
    end

    it "should allow the setting of tls_require_cert" do
      [:never,:allow,:try,:hard,:demand].each do |mode|
        conn = OpenLDAP::Connection.new(LDAP_TLS_URL, tls_require_cert: mode)
        expect(conn.tls_require_cert).to eq(mode)
        conn.unbind
      end
    end
  end

  describe "an instance" do
    before :each do
      @conn = OpenLDAP::Connection.new(LDAP_URL)
    end

    after :each do
      @conn.unbind
    end

    describe "#bind_simple" do
      it "should not raise any errors if the username and password are correct" do
        expect {
          @conn.bind_simple(LDAP_USER, LDAP_PASS)
        }.not_to raise_error
      end

      it "should raise an OpenLDAP::LDAPError if the username and password is not correct" do
        expect {
          @conn.bind_simple(LDAP_USER, LDAP_PASS + "asdfasdf")
        }.to raise_error(OpenLDAP::LDAPOtherError, /Invalid credentials/)
      end
    end

    describe "#tls_require_cert" do
      it "returns a symbol that represents the current TLS certificate requirements" do
        ret = @conn.tls_require_cert
        expect(ret).to be_a(Symbol)
        expect(OpenLDAP::Constants::LDAP_OPT_X_TLS_REQUIRE_CERT_MAP[ret]).not_to be_nil
      end
    end

    describe "#tls_require_cert=(v)" do
      it "raises an ArgumentError if the parameter isn't valid" do
        expect {
          @conn.tls_require_cert = :blabla
        }.to raise_error(ArgumentError)
      end

      it "changes the curent TLS certificate requirements value" do
        @conn.tls_require_cert = :never
        expect(@conn.tls_require_cert).to be(:never)
        @conn.tls_require_cert = :demand
        expect(@conn.tls_require_cert).to be(:demand)
      end
    end

    describe "#search" do
      before :each do
        @conn.bind_simple(LDAP_USER, LDAP_PASS)
      end

      context "when :attributes is not specified" do
        it "should return all attributes" do
          dn = "cn=Kaki Perreault,ou=Human Resources,dc=ldapserver,dc=test"
          attributes = {
           "objectClass"=>["top", "person", "organizationalPerson", "inetOrgPerson"],
           "cn"=>["Kaki Perreault"],
           "sn"=>["Perreault"],
           "description"=>["This is Kaki Perreault's description"],
           "facsimileTelephoneNumber"=>["+1 408 543-4332"],
           "l"=>["Cupertino"],
           "ou"=>["Human Resources"],
           "postalAddress"=>["Human Resources$Cupertino"],
           "telephoneNumber"=>["+1 408 345-5999"],
           "title"=>["Supreme Human Resources Warrior"],
           "userPassword"=>["Password1"],
           "uid"=>["PerreauK"],
           "givenName"=>["Kaki"],
           "mail"=>["PerreauK@ns-mail5.com"],
           "carLicense"=>["ABJQ2O"],
           "departmentNumber"=>["9467"],
           "employeeType"=>["Contract"],
           "homePhone"=>["+1 408 231-8346"],
           "initials"=>["K. P."],
           "mobile"=>["+1 408 333-8274"],
           "pager"=>["+1 408 685-5694"],
           "roomNumber"=>["9210"],
           "manager"=>["cn=Guglielma Hakansson,ou=Management,dc=ldapserver, dc=test"],
           "secretary"=>["cn=Hulda Pufpaff,ou=Payroll,dc=ldapserver, dc=test "]}
          expected = OpenLDAP::Entry.new(dn, attributes)
          
          expect {|b| 
            @conn.search("cn=Kaki Perreault,ou=Human Resources,dc=ldapserver,dc=test", &b)
          }.to yield_with_args(expected)
        end
      end

      context "when :attributes is specified as a space-deliminated string" do
        it "should return only the attributes specified" do
          expected = OpenLDAP::Entry.new(
            "cn=Kaki Perreault,ou=Human Resources,dc=ldapserver,dc=test",
            {
             "carLicense"=>["ABJQ2O"],
             "mobile"=>["+1 408 333-8274"]
            })
          expect {|b| 
            @conn.search("cn=Kaki Perreault,ou=Human Resources,dc=ldapserver,dc=test", 
                         attributes:"carLicense mobile", &b)
          }.to yield_with_args(expected)
        end

      end
    end
  end
end
