require 'sinatra'
require './db_config'
require './app'
require './authentication'

enable :sessions
set :session_secret, "lksjdi2y32zzm9x73x2x362x6x2b8x2z19m"


$config = {}
if(ENV['RACK_ENV'] == 'production')
  $config[:twitter_callback] = "http://photogalleri.es/twitter_login"
else
  $config[:twitter_callback] = "http://localhost:9292/twitter_login"
end

$config[:twitter_key] = ENV['TWITTER_KEY']
$config[:twitter_secret_key] = ENV['TWITTER_SECRET_KEY']


class PhotoGalleries < Sinatra::Application
  disable :run
  disable :reload

  configure :development do
	  set :public_folder, File.dirname(__FILE__) + '/static'
  end
end

run PhotoGalleries
