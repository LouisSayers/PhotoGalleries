require 'sinatra'
require 'haml'
require './models'


get '/admin/' do
  @all_pages = Page.all
  haml :'admin/index', :layout => :'admin/layout'
end

get '/admin/page/create' do
  haml :'/admin/create_a_page', :layout => :'admin/layout'
end

post '/admin/page/create' do
  Page.new_from(params).save()
  redirect '/admin/'
end

get '/admin/page/delete/:page_id' do
  Page.where(_id: params[:page_id]).delete
  redirect '/admin/'
end

