require 'rubygems'
require 'bundler'
require 'bundler/setup'
Bundler.require :default

$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'ruby-promises'
