#encoding:utf-8
require 'sinatra'
# 书签服务器
module BMServerHelper
  def gen_message(content, level='info')
    #success, info, warning, danger
    %{
      <div class="alert alert-#{level} alert-dismissable">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        #{content}
      </div>
    }
  end

  def ensure_logged_in
    if session[:user]
      yield if block_given?
    else
      erb :layout, :layout => false do
        gen_message('Sorry you are not logged, please login first!', 'warning')
      end
    end
  end
end
