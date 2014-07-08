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

queries = ["users", "projects", "project_users", "tasks", "columns"]
targets = [:users, :projects, :project_users, :tasks, :columns]

targets.each do |target|
	collection = db.collection("collection_#{target.to_s}_#{magnitude_order}")
	collection.remove # remove everything on this 
	# collection.create_index("id")
end

data_providers = DataLoader.relational_document_factory magnitude_order
puts "about to start"
testRunner.run("insert magnitude:#{magnitude_order} mongo-docs") do |t|
	threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
		ok = false 
		while !ok
			begin 
				# nothing with query since I only need the data 
				collection = db.collection("#{query}_#{magnitude_order}")
				id = collection.insert(query_data, {:w => 0})
				ok = true
			rescue
				sleep 0	# solution for database connections waiting for over 5 seconds
				print "."
			end
		end
	end
end
