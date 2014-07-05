require "redis"
require "../_raw_data/structured_data_retriever.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

# params
repetitions_per_document = (ARGV[0] || 15).to_i  # number of threads trying to excecute concurrently

# classes required
redis = Redis.new
threadManager = ThreadManager.new 
testRunner = TestRunner.new 

# data required && the script itself
data_retrievers = StructuredDataRetriever.factory
testRunner.run("read #{repetitions_per_document} files") do |t|
	threadManager.map(repetitions_per_document, data_retrievers, :getName, :void) do |name, v|  
		key_name = "cached_#{name}_#{t}"
		html = redis.get(key_name)
	end
end
