require 'sinatra'
require 'parse-ruby-client'

module BMServerOprTag
  def op_tag(table_name, op_params)
    case op_params[:opr]
      when 'delete'      then delete_tag(table_name, op_params[:tag_name])
      when 'edit'     then edit_tag(table_name, op_params[:old_tag_name], op_params[:tag_name])
      when 'add'      then add_tag(table_name, op_params[:tag_name])
      else            #nothing
    end
  end

  def delete_tag(table_name, tag_name)
    tag = get_tag(table_name, tag_name)
    raise "找不到标签:#{tag_name}" unless tag
    tag.parse_delete
  end

  def del_bm_from_tag(table_name, tag_name, bm_id)
    tag = get_tag(table_name, tag_name) || add_tag(table_name, tag_name)
    if bm_id and tag
      tag['bookmark_ids'].delete bm_id
    end
  end

  def add_bm_to_tag(table_name, tag_name, bm_id)
    tag = get_tag(table_name, tag_name)
    if bm_id and tag
      tag['bookmark_ids'].push bm_id
      tag['bookmark_ids'].uniq!
      tag.save
    end
  end

  def add_tag(table_name, tag_name)
    tag = get_tag(table_name, tag_name)
    raise "已经存在标签:#{tag_name}" if tag
    tag = Parse::Object.new(table_name)
    tag['name'] = tag_name
    tag['owner'] = session[:user]['username']
    tag['bookmark_ids'] = []
    tag.save
  end

  def edit_tag(table_name, old_tag_name, new_tag_name)
    tag = get_tag(table_name, old_tag_name)
    raise "找不到标签:#{old_tag_name}" unless tag
    tag['name'] = new_tag_name
    tag.save
  end

  def get_tag(table_name, tag_name)
    tag_query = Parse::Query.new(table_name)
    tag_query.tap do |q|
      q.eq('owner', session[:user]['username'])
      q.eq('name', tag_name)
    end.get.first
  end
end