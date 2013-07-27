# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'yaml'
require 'restclient'

module BookMark
  SERVER_CFG = YAML.load_file(File.join(FILE.dirname(__FILE__), 'parseapi.yml')) 
  class  User
    def initialize(server_cfg)
      @auth_hash = {
        "X-Parse-Application-Id" => server_cfg[:application_id], 
        "X-Parse-REST-API-Key" => server_cfg[:rest_api_key]
      }
      @base_url = server_cfg[:base_url]
    end
    
    #注册
    def signup(username, password)
      headers =@auth_hash.merge({:content_type=>:json, :accept=>:json})
      signup_data = {
        "username"=> username,
        "password"=> password
      }.to_json
      result = RestClient.post("#{@base_url}/users", signup_data, headers)
      return JSON.parse result      
    end
      
    #登录
    def signin(username, password)
      #query = CGI::escape('username='.concat(name).concat('&password=').concat(password))      
      url = "#{@base_url}/login?username=%s&password=%s" % username, password
      result = RestClient.get(url, @auth_hash)
      JSON.parse result
    end
      
  end
end

