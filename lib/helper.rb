#encoding:utf-8
require 'sinatra'
require 'parse-ruby-client'

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

  def op_tag(table_name, op_params)
    tag_query = Parse::Query.new(table_name)
    tag = tag_query.tap do |q|
      q.eq('owner', session[:user]['username'])
      q.eq('name', op_params[:tag_name])
    end.get.first

    case op_params[:op]
      when 'del'
        tag.parse_delete if tag
      when 'del_bm'
        if op_params[:bm_id] and tag
          tag['bookmark_ids'].delete op_params[:bm_id]
        end
      when 'edit'
        if tag
          tag['desc'] = op_params[:desc] if op_params.key?(:desc)
          tag.save
        end
      when 'add'
        unless tag
          tag = Parse::Object.new(table_name)
          tag['name'] = op_params[:tag_name]
          tag['desc'] = op_params[:desc]
          tag['owner'] = session[:user]['username']
          tag['bookmark_ids'] = []
          tag.save
        end

      when 'add_bm'
        if op_params[:bm_id] and tag
          tag['bookmark_ids'].push op_params[:bm_id]
          tag['bookmark_ids'].uniq!
          tag.save
        end
      else
        #nothing
    end

  end

  def add_bm(bm_table_name, tag_table_name, op_params)
    owner = session[:user]['username']
    tags = op_params[:tags] || ''
    tags = tags.split(/\s*;\s*/) if tags #tags split by ';'

    #save bookmark table and return result.
    bm = Parse::Object.new(bm_table_name, {
        'url' => op_params[:url],
        'desc' => op_params[:desc],
        'tags' => tags,
        'owner' => owner
    }).save

    #update the tags
    tag_params = {:tag_name => '', :op => 'add_bm', :bm_id => bm.parse_object_id}
    tags.each do |t|
      tag_params[:tag_name] = t
      op_tag(tag_table_name, tag_params)
    end
  end

  def del_bm(bm_table_name, tag_table_name, op_params)
    owner = session[:user]['username']
    bm = Parse::Query.new(bm_table_name).tap do |q|
      q.eq('owner', owner)
      q.eq('objectId', op_params[:bm_id])
    end.get.first
    #delete the bookmark_id element in all tags
    tag_op_hash = {:op => 'del_bm', :bm_id => op_params[:bm_id]}
    bm['tags'].each do |tag_name|
      tag_op_hash[:tag_name] = tag_name
      op_tag(tag_table_name, tag_op_hash)
    end
    #delete the bookmark
    bm.parse_delete if bm
  end

  def edit_bm(bm_table_name, tag_table_name, op_params)
    del_bm(bm_table_name, tag_table_name, op_params)
    add_bm(bm_table_name, tag_table_name, op_params)
  end

  def get_bms_by_keyword(bms, keyword)
    return bms unless keyword =~ /\w+/
    bms.select do |b|
      b['url'].include? keyword or
          b['desc'].include? keyword or
          b['tags'] && b['tags'].any? { |t| t.include? keyword }
    end
  end

  def get_bms_by_tag(bm_table_name, tag_table_name, tag_name)
    tag = Parse::Query.new(tag_table_name).tap do |q|
      q.eq('owner', session[:user]['username'])
      q.eq('name', tag_name)
    end.get.first
    if tag
      bm_ids = tag['bookmark_ids'] || []
      return [] if bm_ids.length <= 0
      Parse::Query.new(bm_table_name).tap do |q|
        q.eq('owner', session[:user]['username'])
        q.value_in('objectId', bm_ids)
      end.get
    else
      @head_message[session[:user]['username']] = gen_message("对不起,找不到书签:#{tag_name}.", 'warning')
      []
    end
  end
end
