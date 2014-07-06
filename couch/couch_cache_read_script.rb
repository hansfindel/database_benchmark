require "./couch.rb" 
require "JSON"
require "../_raw_data/structured_data_retriever.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

# params
repetitions_per_document = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently
# classes required
threadManager = ThreadManager.new 
testRunner = TestRunner.new 
server = Couch::Server.new("localhost", "5984")
# data required && the script itself
data_retrievers = StructuredDataRetriever.factory
testRunner.run("insert #{repetitions_per_document} couch-documents") do |t|
	
	threadManager.map(repetitions_per_document, data_retrievers, :getName, :void) do |name, v|  
		key_name = "cached_#{name}_#{t}"
		html = server.get("/cache_#{repetitions_per_document}/#{key_name}")
	end
end
