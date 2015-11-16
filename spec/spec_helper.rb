require 'rubygems'
require 'bundler'
Bundler.setup :default, :test

require 'rspec/its'

require 'simplecov'
SimpleCov.start

LDAP_HOSTNAME = ENV["LDAPSERVER_HOSTNAME"]
LDAP_USER     = ENV["LDAPSERVER_USER"]
LDAP_PASS     = ENV["LDAPSERVER_PASS"]
LDAP_URL      = ENV["LDAPSERVER_URL"]
LDAP_TLS_URL  = ENV["LDAPSERVER_TLS_URL"]



SimpleCov.start do
  project_root = RSpec::Core::RubyProject.root
end 

RSpec.configure do |config|
end

require 'openldap'
