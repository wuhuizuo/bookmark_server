#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'

Bundler.require

require "./lib/main"
run Sinatra::Application

#>rackup -s thin -p 4567 config.ru