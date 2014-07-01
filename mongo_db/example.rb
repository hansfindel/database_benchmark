# run instructions: ruby example.rb

require 'rubygems'  # not necessary for Ruby 1.9
require 'mongo'

include Mongo

mongo_client = MongoClient.new("localhost", 27017)

mongo_client.database_info.each { |info| puts info.inspect }

db = mongo_client.db("my_example_db")

coll = db.collection("testCollection")

doc = {"name" => "MongoDB", "type" => "database", "count" => 1, "info" => {"x" => 203, "y" => '102'}}
id = coll.insert(doc)

coll.create_index("name")