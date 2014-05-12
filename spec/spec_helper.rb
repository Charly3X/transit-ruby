# Copyright (c) Cognitect, Inc.
# All rights reserved.

unless Dir.exist?('transit/simple-examples')
  puts <<-MSG
Before you can run the rspec examples, you need to install the
exemplar files from the https://github.com/cognitect/transit repo
as follows:

    git submodule init
    git submodule update

This actually installs the entire transit repo as a submodule at
the project root, putting the examplars in ./transit/simple-examples.

MSG
  exit
end

require 'rspec'
require 'wrong/adapters/rspec'
require 'transit'
require 'transit_marshaler'
require 'spec_helper-local' if File.exist?(File.expand_path('../spec_helper-local.rb', __FILE__))

RSpec.configure do |c|
  c.alias_example_to :fit, :focus => true
  c.filter_run_including :focus => true, :focused => true
  c.run_all_when_everything_filtered = true
end

ALPHA_NUM = 'abcdefghijklmnopABCDESFHIJKLMNOP_0123456789'

def random_alphanum
  ALPHA_NUM[rand(ALPHA_NUM.size)]
end

def random_string(max_length=10)
  l = rand(max_length) + 1
  (Array.new(l).map {|x| random_alphanum}).join
end

def random_strings(max_length=10, n=100)
  Array.new(n).map {random_string(max_length)}
end

def random_symbol(max_length=10)
  random_string(max_length).to_sym
end

def ints_centered_on(m, n=5)
  ((m-n)..(m+n)).to_a
end

def array_of_symbols(m, n=m)
  seeds = (0...m).map {|i| ("key%04d" % i).to_sym}
  seeds.cycle.take(n)
end

def hash_of_size(n)
  Hash[array_of_symbols(n).zip((0..n).to_a)]
end

Person = Struct.new("Person", :first_name, :last_name, :birthdate)

class PersonHandler
  def tag(_) "person"; end
  def rep(p) {:first_name => p.first_name, :last_name => p.last_name, :birthdate => p.birthdate} end
  def string_rep(p) nil end
end

class DateHandler
  def tag(_); "D"; end
  def rep(d) d.to_s end
  def string_rep(d) rep(d) end
end
