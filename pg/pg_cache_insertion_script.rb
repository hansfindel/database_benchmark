# pg_cache_insertion_script.rb
# require 'nokogiri'
require 'pg'
require "../_raw_data/structured_data_provider.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

conn=PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db")

conn.exec_params("DROP TABLE IF EXISTS mycaches") # should skip this if doesn't exist
conn.exec_params("CREATE TABLE mycaches (
    name  VARCHAR(50) NOT NULL,
    html TEXT )" );
conn.close
puts "database created"
# params
repetitions_per_document = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently
# classes required
threadManager = ThreadManager.new 
testRunner = TestRunner.new 
data_providers = StructuredDataProvider.factory

testRunner.run("insert #{repetitions_per_document} pg-rows") do |t|
	threadManager.map(repetitions_per_document, data_providers, :getName, :getHTML) do |name, html|  
		PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db") do |conn|
			key_name = "cached_#{name}_#{t}"
			conn.exec_params( 'INSERT INTO mycaches (name, html) VALUES ($1, $2)', [key_name, html] )
		end
		# conn.flush() unless conn.finished?
		
	end
	
end


# conn.close

# more concurrent connections! -> http://stackoverflow.com/questions/14049185/postgresql-evolutions-psqlexception-fatal-sorry-too-many-clients-already 