#encoding:utf-8
require 'thin'
require 'yaml'
require 'sinatra'
require 'parse-ruby-client'
require_relative 'lib/helper'
require_relative 'lib/opr_bm'
require_relative 'lib/opr_tag'

class BMServer < Sinatra::Application
  set :public_folder, File.dirname(__FILE__) + '/static'
  enable :sessions
  helpers BMServerHelper
  helpers BMServerOprBm
  helpers BMServerOprTag

  def initialize
    super
    @serv_cfg = YAML.load_file('conf/parseapi.yml')
    Parse.init :application_id => @serv_cfg[:application_id], :api_key => @serv_cfg[:rest_api_key]
    @head_message = {}
  end

  ['/', '/index'].each do |url|
    get url do
      erb :index
    end
  end

  get '/tags' do
    ensure_logged_in do
      tag_query = Parse::Query.new(@serv_cfg[:tag_name])
      tags = tag_query.eq('owner', session[:user]['username']).get
      erb :tags, :locals => {:tags => tags}
    end
  end

  post '/tags' do
    puts params.inspect
    op_tag(@serv_cfg[:tag_name], params)
    redirect '/tags'
  end

  get '/bookmarks' do
    ensure_logged_in do
      request_tag, request_keyword = params[:tag], params[:search]

      if request_tag
        bms = get_bms_by_tag(@serv_cfg[:bm_name], @serv_cfg[:tag_name], request_tag)
      else
        bookmark_query = Parse::Query.new(@serv_cfg[:bm_name])
        bookmark_query.eq('owner', session[:user]['username'])
        bms = bookmark_query.get
      end

      #search
      bms = get_bms_by_keyword(bms, request_keyword) if request_keyword

      erb :bookmarks, :locals => {:bookmarks => bms}
    end
  end

  post '/bookmarks' do
    send("#{params[:opr]}_bm", @serv_cfg[:bm_name], @serv_cfg[:tag_name], params)
    redirect '/bookmarks'
  end

  post '/signup' do
    email, name, password = params[:email], params[:username], params[:password]
    unless name =~ /\w+/ && password =~ /\w+/
      erb :index, :locals => {:message => gen_message('Length of username or password must > 0 !', 'danger')}
    else
      user = Parse::User.new({'username' => name, 'password' => password, 'email' => email})
      begin
        result = user.save
        session[:user] = result
        @head_message[name] = gen_message('Signup success.', 'success')
        redirect '/'
      rescue Parse::ParseProtocolError => e
        if e.error =~ %r<username\s*#{name}\s*already\s*taken>
          erb :index, :locals => {:message => gen_message('用户名已存在,请找另外一个名字吧^..^....', 'danger')}
        end
      end
    end
  end

  post '/signin' do
    name, password = params[:username], params[:password]
    return erb :index if name.empty? || password.empty?
    begin
      user = Parse::User.authenticate(name, password)
      session[:user] = user
      @head_message[name] = gen_message('Login success.', 'success')
      redirect "/"
    rescue Parse::ParseProtocolError
      erb :index, :locals => {:message => gen_message('用户名或者密码错误^,^', 'danger')}
    end
  end

  # signout
  get '/signout' do
    session.clear
    redirect '/'
  end


end

BMServer.run!
