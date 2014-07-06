# pg_cache_insertion_script.rb
# require 'nokogiri'
require 'pg'
require "../_raw_data/structured_data_retriever.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

[false, true].each do |do_hash|

	sufix = ""
	if do_hash
		sufix = "_with_hash_index"
	end
	# params
	repetitions_per_document = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently
	# classes required
	threadManager = ThreadManager.new 
	testRunner = TestRunner.new 
	data_retrievers = StructuredDataRetriever.factory

	testRunner.run("read #{repetitions_per_document} pg#{sufix}-rows") do |t|
		threadManager.map(repetitions_per_document, data_retrievers, :getName, :void) do |name, v|  
			PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db") do |conn|
				key_name = "cached_#{name}_#{t}"
				conn.send_query( "select html from mycaches#{sufix} where name = ? limit 1", [key_name] )
			end
		end
	end
end
