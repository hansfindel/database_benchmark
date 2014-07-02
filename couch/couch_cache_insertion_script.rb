require "./couch.rb" 
require "JSON"
require "../_raw_data/structured_data_provider.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

# params
repetitions_per_document = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently
# classes required
threadManager = ThreadManager.new 
testRunner = TestRunner.new 

server = Couch::Server.new("localhost", "5984")
begin
	server.delete("/cache_#{repetitions_per_document}")
end
db = server.put("/cache_#{repetitions_per_document}", "")
# data required && the script itself
data_providers = StructuredDataProvider.factory
testRunner.run("insert #{repetitions_per_document} couch-documents") do |t|
	
	threadManager.map(repetitions_per_document, data_providers, :getName, :getHTML) do |name, html|  
		key_name = "cached_#{name}_#{t}"
		doc = { name: key_name + "-#{Time.now.to_i}", html: html}.to_json
		server.put("/cache_#{repetitions_per_document}/#{key_name}", doc)
	end
end
