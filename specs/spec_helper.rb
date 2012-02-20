require 'uri'
require 'mongoid'

$db = Mongo::Connection.new("localhost").db("Test-PhotoGalleries")

Mongoid.configure do |config|
  config.master = $db
end
