#encoding:utf-8
require 'sinatra'
require 'thin'
require 'parse-ruby-client'
require 'yaml'

SERV_CFG = YAML.load_file('parseapi.yml')
OBJECT_NAME = SERV_CFG[:object_name]
Parse.init :application_id => SERV_CFG[:application_id],
:api_key        => SERV_CFG[:rest_api_key]

set :public_folder, File.dirname(__FILE__) + '/static'
enable :sessions

get '/' do
  erb :index
end



get '/index' do
  erb :index
end

get '/home' do
  if session[:user].nil?
    redirect "/signin"
  end
  objectId = session[:user]["objectId"]
  bookmark_query = Parse::Query.new(SERV_CFG[:object_name])
  bookmark_query.eq("owner", session[:user]["username"])
  bookmarks = bookmark_query.get

  erb :home, :locals => {:bookmarks => bookmarks}
end

# signup
get '/signup' do
  erb :signup
end

post '/signup' do
  name, password = params[:username], params[:password]
  confirm_password = params[:confirm_password]
  if name.empty? or
  password.empty? or
  confirm_password.empty? or
  password != confirm_password
    return erb :signup
  end

  user = Parse::User.new({"username" => name, "password" => password})
  begin
    result = user.save
    session[:user] = result
    redirect "/home"
  rescue Parse::ParseProtocolError => e
    if e.error =~ %r<username\s*#{name}\s*already\s*taken>
      "用户名已存在,请找另外一个名字吧^..^....<a href='/signup'>返回</a>"
    end
  end


end

# log in
get '/signin' do
  erb :signin
end

post '/signin' do
  name, password = params[:username], params[:password]
  return erb :signin if name.empty? || password.empty?
  begin
    user = Parse::User.authenticate(name, password)
    session[:user] = user
    redirect "/home"
  rescue Parse::ParseProtocolError
    "用户名或者密码错误^,^'<a href='/signin'>返回</a>"
  end
end

# signout
get '/signout' do
  session.clear
  redirect "/index"
end

post '/create' do
  url = params[:url]
  desc = params[:desc]
  group = params[:group]
  user = session[:user]["username"]
  Parse::Object.new(OBJECT_NAME, {
    "url" => url,
    "desc" => desc,
    "group" => group,
    "owner" => user
  }
  ).save

  redirect "/home"
end

post '/edit' do
  item = Parse::Query.new(OBJECT_NAME).
  eq("objectId", params[:objectId]).get.first
  item["url"] = params[:url]
  item["desc"] = params[:desc]
  item["group"] = params[:group]
  item.save if item
  redirect "/home"
end

post '/destroy' do
  item = Parse::Query.new(OBJECT_NAME).
  eq("objectId", params[:objectId]).get.first
  item.parse_delete if item
  redirect "/home"
end