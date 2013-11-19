#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'

Bundler.require

require "./lib/main"
run Sinatra::Application
