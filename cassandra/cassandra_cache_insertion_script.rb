# gem install 'cql-rb'  - in ruby 2.0.0
require 'cql'

require "../_raw_data/structured_data_provider.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

repetitions_per_document = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently

# classes required
threadManager = ThreadManager.new 
testRunner = TestRunner.new 
data_providers = StructuredDataProvider.factory


client = Cql::Client.connect(hosts: ['127.0.0.1'])
client.use('cache_measurements')

testRunner.run("insert #{repetitions_per_document} pg-rows") do |t|
	
	threadManager.map(repetitions_per_document, data_providers, :getName, :getHTML) do |name, html|  
		key_name = "cached_#{name}_#{t}"
		client.execute("INSERT INTO casscaches (name, html) VALUES (?,?)",  key_name, html  )
	end

end

client.close
