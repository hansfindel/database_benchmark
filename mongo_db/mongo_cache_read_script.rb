# enconding: utf-8
require 'mongo'
require "bson"
require "json"
require "../_raw_data/structured_data_retriever.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"
include Mongo
include BSON
include JSON

repetitions_per_document = (ARGV[0] || 15).to_i  # number of threads trying to excecute concurrently

mongo_client = MongoClient.new("localhost", 27017)
db = mongo_client.db("mongo_cache_script")
collection = db.collection("cached_htmls_#{repetitions_per_document}")
threadManager = ThreadManager.new 
testRunner = TestRunner.new 

# data required && the script itself
data_retrievers = StructuredDataRetriever.factory
testRunner.run("read #{repetitions_per_document} documents") do |t|
	threadManager.map(repetitions_per_document, data_retrievers, :getName, :void) do |name, v|  
		key_name = "cached_#{name}_#{t}"
		doc = {name: key_name}
		html = collection.find(doc)
	end
end