require 'spec_helper'
require 'openldap/connection'
require 'set'


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
          dn = "cn=Mark Martinez,ou=Accounting,dc=ldapserver,dc=test"
          attributes = {
            "objectClass" => ["top", "person", "organizationalPerson","inetOrgPerson"],
            "cn" => ["Mark Martinez"],
            "sn" => ["Martinez"],
            "description" => ["This is Mark Martinez's description"],
            "facsimileTelephoneNumber" => ["+1 326-683-9143"],
            "l" => ["Springfield"],
            "ou" => ["Accounting"],
            "postalAddress" => ["Accounting$Springfield"],
            "telephoneNumber" => ["+1 425-707-6623"],
            "title" => ["Junior Accounting Writer"],
            "userPassword" => ["Password1"],
            "uid" => ["MarkMartinez"],
            "givenName" => ["Mark"],
            "mail" => ["MarkMartinez@ldapserver.test"],
            "departmentNumber" => ["3267"],
            "employeeType" => ["Contract"],
            "homePhone" => ["+1 404-745-3181"],
            "initials" => ["M. M."],
            "mobile" => ["+1 465-996-2687"],
            "pager" => ["+1 277-566-7183"],
            "roomNumber" => ["196"]
          }
          expected = OpenLDAP::Entry.new(dn, attributes)
          
          expect {|b| 
            @conn.search(dn, &b)
          }.to yield_with_args(expected)
        end
      end

      context "when :attributes is specified as a space-deliminated string" do
        it "should return only the attributes specified" do
          dn = "cn=Mark Martinez,ou=Accounting,dc=ldapserver,dc=test"
          expected = OpenLDAP::Entry.new(dn,
            {
             "employeeType"=>["Contract"],
             "initials"=>["M. M."],
             "roomNumber"=>["196"]
            })
          expect {|b| 
            @conn.search(dn, 
                         attributes:"employeeType initials roomNumber", &b)
          }.to yield_with_args(expected)
        end
      end

      
      PAYROLL_OU = "ou=Payroll,ou=Accounting,dc=ldapserver,dc=test"
      PAYROLL_CHILDREN = [
        "cn=Brian Harris,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Carol Robinson,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Donna Martin,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Edward Jones,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Elizabeth Brown,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Elizabeth Carter,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Frank Davis,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Helen Torres,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Jason Martin,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Jeffrey Hill,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Jennifer Rodriguez,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Joseph Robinson,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Jose Sanchez,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Jose Wright,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Kenneth Wright,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Kevin Garcia,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Maria Young,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Mary Perez,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Mary Phillips,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Nancy White,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Nancy Williams,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Robert Nelson,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Ruth Allen,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Ruth Lee,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Ruth Wilson,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Steven Mitchell,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Susan Perez,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=Timothy Carter,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=William Hernandez,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=William Nelson,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test",
        "cn=William White,ou=Payroll,ou=Accounting,dc=ldapserver,dc=test"
      ]

      shared_examples_for "scope set to :subtree" do
        it "searches the basedn and all of its subchildren" do

          found_dns = []
          expected = PAYROLL_CHILDREN.dup
          expected << PAYROLL_OU
          @conn.search(PAYROLL_OU, search_opts) do |entry|
            found_dns << entry.dn
          end
          expect(found_dns).to match_array(expected)
        end
      end

      context "when :scope is not defined" do
        let(:search_opts) { {} }
        it_behaves_like "scope set to :subtree"
      end

      context "when :scope is :subtree" do
        let(:search_opts) { {scope: :subtree} }
        it_behaves_like "scope set to :subtree"
      end

      context "when :scope is :onelevel" do
        it "searches only the immediate children of the basedn" do
          expected_dns =  Set.new([
            "ou=Accounting,dc=ldapserver,dc=test",
            "ou=Human Resources,dc=ldapserver,dc=test",
            "ou=Information Technology,dc=ldapserver,dc=test",
            "ou=Administrative,dc=ldapserver,dc=test"
          ])

          found_dns = Set.new

          @conn.search("dc=ldapserver,dc=test", scope: :onelevel, filter: "(objectClass=*)", attributes:"dn") do |entry|
            found_dns << entry.dn
          end
          expect(found_dns).to eq(expected_dns)
        end
      end

      context "when :scope is :base" do
        it "searches only the basedn" do
          expected_dns =  Set.new([
            "ou=Accounting,dc=ldapserver,dc=test"
          ])

          found_dns = Set.new

          @conn.search("ou=Accounting,dc=ldapserver,dc=test", scope: :base, filter: "(objectClass=*)", attributes:"dn") do |entry|
            found_dns << entry.dn
          end
          expect(found_dns).to eq(expected_dns)
        end
      end

      context "when :scope is :subordinate" do
        it "searches all decendants of the basedn" do
          found_dns = []
          expected = PAYROLL_CHILDREN.dup
          @conn.search(PAYROLL_OU, scope: :subordinate) do |entry|
            found_dns << entry.dn
          end
          expect(found_dns).to match_array(expected)
        end
      end

      context "when :scope is invalid" do
        it "raises ArgumentError" do
          expect {
            @conn.search(PAYROLL_OU, scope: :foobar) do |entry|
            end
          }.to raise_error(ArgumentError)
        end
      end

    end

  end

  context "when an instance is garbage collected" do
    context "when unbind has not been called" do
      it "should automatically close the LDAP handle" do
        expect_any_instance_of(OpenLDAP::UnbindHandler).to receive(:call).and_call_original
        conn = OpenLDAP::Connection.new(LDAP_URL)
        conn = nil
        ObjectSpace.garbage_collect
      end
    end

    context "when unbind has already been called" do
      it "should not attempt to close the LDAP handle" do
        expect_any_instance_of(OpenLDAP::UnbindHandler).not_to receive(:call).and_call_original
        conn = OpenLDAP::Connection.new(LDAP_URL)
        conn.unbind
        conn = nil
        ObjectSpace.garbage_collect
      end
    end
  end


end
