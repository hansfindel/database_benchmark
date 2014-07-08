require "./couch.rb" 
require "JSON"
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

# params
magnitude_order = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently
# classes required
threadManager = ThreadManager.new 
testRunner = TestRunner.new 
server = Couch::Server.new("localhost", "5984")
# data required && the script itself
queries = ["users", "projects"]
targets = [:users, :projects]
data_providers = DataLoader.nested_document_factory magnitude_order
testRunner.run("read #{magnitude_order} couch-documents") do |t|
	threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
		if query_data[:email].nil?
			Thread.new do |thread|
				key_name = "#{query}_#{query_data[:id]}_#{t}"
				doc = server.get("/cache_#{repetitions_per_document}/#{key_name}")
				doc[:user_ids].includes?(0)
			end
		end	
		
		
	end
end
