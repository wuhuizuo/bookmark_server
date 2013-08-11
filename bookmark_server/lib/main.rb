#encoding: utf-8
require 'sinatra'
require 'thin'



set :public_folder, File.dirname(__FILE__) + '/static'
enable :sessions

