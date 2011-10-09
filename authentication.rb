require 'sinatra'
require 'rpx_now'

RPXNow.api_key =ENV['RPX_NOW_KEY']

class Person
  include Mongoid::Document
  store_in :people

  field :login_identifier, type: String
  field :session_ids, type: Array

  def login
    self.session_ids = [] if self.session_ids.nil?
    self.session_ids << Digest::MD5.hexdigest("#{self.login_identifier}#{Time.now}").to_s()
  end

  def logout
    self.session_ids = []
  end

  def self.with(session_id)
    Person.any_in(session_ids: [session_id])[0]
  end
end

def is_user_logged_in?(user, session_id)
  session_id != '' and !session_id.nil? and !user.nil?
end


before '/admin/*' do
  session_id = session[:id]

  user = Person.where(session_ids: session_id) if !session_id.nil?

  @logged_in = is_user_logged_in?(user, session_id)
  redirect '/login' if not @logged_in
end



get '/login' do
  haml :login, :layout => :'admin/layout'
end

get '/logout' do
  user = Person.where(session_ids: session[:id])
  if !user.empty?
    user = user[0]
    user.logout
    user.save
  end
  session[:id] = ''
  @logged_in = false
  redirect '/login'
end

post '/token_taker' do
  token_info = params[:token]
  data = RPXNow.user_data(token_info)
  redirect '/login' unless data

  if Person.exists?(conditions: {login_identifier: data[:identifier]})
     user = Person.first(conditions: {login_identifier: data[:identifier]})
  else
     user = Person.new(:login_identifier => data[:identifier],
                       :name => data[:name],
                       :email => data[:email],
                       :roles => [:general])
  end
  user.login
  saved_successfully = user.save
  session[:id] = user.session_ids.last if saved_successfully and user.login_identifier == 'https://www.google.com/profiles/113217088635571530646'
  redirect '/admin/'
end