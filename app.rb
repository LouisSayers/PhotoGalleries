require 'sinatra'
require 'haml'
require './models'


get %r{^(?!/admin/.*$)(.*)} do |page_name|
  page = Page.where(name: page_name).first
  return haml :error_page if page.nil?

  return haml :html_content, :locals => {:content => page.content} if page.markup == 'html'
  return haml page.content.to_s if page.markup == 'haml'

  return haml :error_page
end

get '/admin/' do
  @all_pages = Page.all
  haml :'admin/index', :layout => :'admin/layout'
end

get '/admin/page/create' do
  haml :'/admin/page', :layout => :'admin/layout'
end

post '/admin/page/create' do
  Page.new_from(params).save()
  redirect '/admin/'
end

get '/admin/page/edit/:page_id' do
  @page = Page.where(_id: params[:page_id]).first
  haml :'/admin/page', :layout => :'admin/layout'
end

post '/admin/page/save/:page_id' do
  #Update the page Page.update(params[:page_id], params)
  redirect '/admin/'
end

get '/admin/page/delete/:page_id' do
  Page.where(_id: params[:page_id]).delete
  redirect '/admin/'
  end

