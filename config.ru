#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'main.rb'
run Sinatra::Application
