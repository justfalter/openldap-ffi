#!/usr/bin/env ruby

require 'erb'

FIRST_NAMES = File.read('data/first-names.txt').lines.map {|x| x.chomp}.uniq
LAST_NAMES = File.read('data/last-names.txt').lines.map {|x| x.chomp}.uniq
GROUP_NAMES = File.read('data/groups.txt').lines.map {|x| x.chomp}.uniq
TOWN_NAMES = File.read('data/towns.txt').lines.map {|x| x.chomp}.uniq
EMPLOYEE_TYPES = File.read('data/employee_types.txt').lines.map {|x| x.chomp}.uniq
USER_TEMPLATE = ERB.new File.read('templates/user.erb')
OU_TEMPLATE   = ERB.new File.read('templates/ou.erb')
DOMAIN_TEMPLATE = ERB.new File.read('templates/domain.erb')

class OU
  attr_reader :name, :domain, :dn
  def initialize(name, domain)
    parts = name.split('/').reverse
    @name = parts.first
    @domain = domain
    z = parts.map {|x| "ou=#{x}" }.join(',')
    @dn = [z,@domain.dn].join(',')
  end

  def generate
    OU_TEMPLATE.result binding
  end
end

class Domain
  attr_reader :domain, :dn, :hostname
  def initialize(domain)
    @domain = domain.downcase
    parts = @domain.split('.')
    @hostname = parts.first
    @dn= parts.map {|x| "dc=#{x}"}.join(',')
  end

  def generate
    DOMAIN_TEMPLATE.result binding
  end
end

class User
  attr_reader :first_name, :last_name, :ou, :dn, :whole_name, :uid, :town, 
    :employee_type
  def initialize(first_name, last_name, ou)
    @first_name = first_name
    @last_name = last_name
    @whole_name = [first_name, last_name].join(' ')
    @ou = ou
    @dn = ["cn=" + whole_name,ou.dn].join(',')
    @town = TOWN_NAMES.sample(1).first
    @employee_type = EMPLOYEE_TYPES.sample(1).first

    

    @uid = [first_name, last_name].join('').gsub(/[^A-Za-z]/, '')
  end

  def rand_phone
    area_code = 200 + rand(300)
    num1 = 500 + rand(500)
    num2 = rand(10000)
    "+1 #{area_code}-#{num1}-#{num2}"
  end

  def generate
    USER_TEMPLATE.result binding
  end
end

domain = Domain.new(ARGV.shift)
ous = GROUP_NAMES.map {|x| OU.new(x,domain) }

puts domain.generate

ous.each do |ou|
  puts ou.generate
end

require 'set'
used_names = Set.new
ous.each do |ou|
  count = 20 + rand(20)

  count.times do
    first_name = FIRST_NAMES.sample(1).first
    last_name = LAST_NAMES.sample(1).first
    redo if used_names.include? [first_name,last_name]
    used_names << [first_name,last_name]

    user = User.new(first_name,last_name,ou)
    puts user.generate
  end
end
