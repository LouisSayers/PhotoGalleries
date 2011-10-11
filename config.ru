require 'sinatra'
require './db_config'
require './app'
#require './authentication'

enable :sessions
set :session_secret, "lksjdi2y32zzm9x73x2x362x6x2b8x2z19m"

run Sinatra::Application