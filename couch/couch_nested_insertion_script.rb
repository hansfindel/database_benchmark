# enconding: utf-8
require "./couch.rb" 
require "JSON"
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

magnitude_order = (ARGV[0] || 1).to_i  # number of threads trying to excecute concurrently
server = Couch::Server.new("localhost", "5984")

queries = ["users", "projects"]
targets = [:users, :projects]
queries.each do |query|
	begin
		server.delete("/nested_#{query}_#{magnitude_order}")
		rescue 
		server.put("/nested_#{query}_#{magnitude_order}", "")	
	end
end

threadManager = ThreadManager.new 
testRunner = TestRunner.new 
data_providers = DataLoader.nested_document_factory magnitude_order
puts "about to start"
testRunner.run("insert magnitude:#{magnitude_order} couch-docs") do |t|
	threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
		Thread.new do |thread|
			key_name = "#{query}_#{query_data[:id]}_#{t}"
			server.put("/nested_#{query}_#{magnitude_order}/#{key_name}", query_data.to_json)
		end
	end
end
