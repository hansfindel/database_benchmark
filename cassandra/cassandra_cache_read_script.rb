# gem install 'cql-rb'  - in ruby 2.0.0
require 'cql'

require "../_raw_data/structured_data_retriever.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

repetitions_per_document = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently

# classes required
threadManager = ThreadManager.new 
testRunner = TestRunner.new 
data_retrievers = StructuredDataRetriever.factory


client = Cql::Client.connect(hosts: ['127.0.0.1'])
client.use('cache_measurements')
statement = client.prepare('SELECT html FROM casscaches WHERE name = ?')

testRunner.run("read #{repetitions_per_document} pg-rows") do |t|	
	threadManager.map(repetitions_per_document, data_retrievers, :getName, :void) do |name, v|  
		key_name = "cached_#{name}_#{t}"
		#### client.execute("INSERT INTO casscaches (name, html) VALUES (?,?)",  key_name, html  )
		html = statement.execute(name)
	end
end

client.close
