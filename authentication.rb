require 'sinatra'
require 'twitter_oauth'
require './models'

def is_user_logged_in?(user, session_id)
  session_id != '' and !session_id.nil? and !user.nil?
end

before do
  @twitter_client = TwitterOAuth::Client.new(
    :consumer_key => $config[:twitter_key],
    :consumer_secret => $config[:twitter_secret_key]
  )
end

before '/admin/*' do
  session_id = session[:id]
  user = Person.where(session_ids: session_id) if !session_id.nil?
  @logged_in = is_user_logged_in?(user, session_id)
  pass if @logged_in

  #If not logged in...
  request_token = @twitter_client.request_token(:oauth_callback => $config[:twitter_callback])

  session[:request_token] = request_token.token
  session[:request_token_secret] = request_token.secret

  redirect request_token.authorize_url.sub(/authorize\?/, "authenticate?")
end


get '/twitter_login' do
  begin
    @access_token = @twitter_client.authorize(
      session[:request_token],
      session[:request_token_secret],
      :oauth_verifier => params[:oauth_verifier]
    )
  rescue OAuth::Unauthorized
  end

  if @twitter_client.authorized?
    twitter_id = @twitter_client.info["id"]
    redirect '/' if twitter_id.nil? or twitter_id == ""

    person = Person.get_or_create(twitter_id, 'twitter')
    person.login
    person.save
    session[:id] = person.session_ids[0]

    redirect '/admin/'
  else
    redirect '/'
  end
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
  redirect '/'
end
