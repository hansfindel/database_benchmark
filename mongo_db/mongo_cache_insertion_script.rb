# enconding: utf-8
require 'mongo'
require "bson"
require "json"
require "../_raw_data/structured_data_provider.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"
include Mongo
include BSON
include JSON

repetitions_per_document = (ARGV[0] || 15).to_i  # number of threads trying to excecute concurrently

mongo_client = MongoClient.new("localhost", 27017)
db = mongo_client.db("mongo_cache_script")
collection = db.collection("cached_htmls_#{repetitions_per_document}")
collection.create_index("name")

threadManager = ThreadManager.new 
testRunner = TestRunner.new 

# data required && the script itself
data_providers = StructuredDataProvider.factory
testRunner.run("insert #{repetitions_per_document} documents") do 
	threadManager.map(repetitions_per_document, data_providers, :getName, :getHTML) do |name, html|  
		key_name = "cached_#{name}"
		doc = {name: key_name, html: html}
		ok = false 
		while !ok
			begin 
				id = collection.insert(doc)
				ok = true
			rescue
				# solution for database connections waiting for over 5 seconds
				sleep 0
			end
		end
	end
end