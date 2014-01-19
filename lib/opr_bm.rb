require 'sinatra'
require 'parse-ruby-client'

module BMServerOprBm
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
    bm_id = bm.parse_object_id
    tags.each { |tag_name| add_bm_to_tag(tag_table_name, tag_name, bm_id) }
  end

  def delete_bm(bm_table_name, tag_table_name, op_params)
    owner = session[:user]['username']
    bm = Parse::Query.new(bm_table_name).tap do |q|
      q.eq('owner', owner)
      q.eq('objectId', op_params[:bm_id])
    end.get.first
    #delete the bookmark_id elcloud-bmement in all tags
    bm['tags'].each { |tag_name| del_bm_from_tag(tag_table_name, tag_name, op_params[:bm_id]) }
    #delete the bookmark
    bm.parse_delete if bm
  end

  def edit_bm(bm_table_name, tag_table_name, op_params)
    delete_bm(bm_table_name, tag_table_name, op_params)
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