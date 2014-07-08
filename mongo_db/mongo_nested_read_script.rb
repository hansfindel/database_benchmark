# enconding: utf-8
require 'mongo'
require "bson"
require "json"
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"
include Mongo
include BSON
include JSON

magnitude_order = (ARGV[0] || 1).to_i  # number of threads trying to excecute concurrently
mongo_client = MongoClient.new("localhost", 27017)
db = mongo_client.db("mongo_cache_script")

threadManager = ThreadManager.new 
testRunner = TestRunner.new 

queries = ["users", "projects"]
targets = [:users, :projects]

targets.each do |target|
	collection = db.collection("collection_#{target.to_s}_#{magnitude_order}")
	collection.remove # remove everything on this 
	# collection.create_index("id")
end

data_providers = DataLoader.nested_document_factory magnitude_order
puts "about to start"
testRunner.run("insert magnitude:#{magnitude_order} mongo-docs") do |t|
	threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
		if query_data[:email].nil?
			collection = db.collection("#{query}_#{magnitude_order}")
			# query_hash = {columns: {tasks: {assigned_to: 0}}} #query_data
			query_hash = {user_ids: 0} #query_data
			obj = collection.find(query_hash)
			count = obj.count
			# puts obj.count
		end
	end
end
