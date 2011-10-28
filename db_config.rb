require 'uri'
require 'mongoid'

if ENV['MONGOHQ_URL'] then #configure db for heroku
  uri = URI.parse(ENV['MONGOHQ_URL'])
  conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
  $db = conn.db(uri.path.gsub(/^\//, ''))
else #configure db for localhost ;)
  $db = Mongo::Connection.new("localhost").db("PhotoGalleries")
end

Mongoid.configure do |config|
  config.master = $db
end



