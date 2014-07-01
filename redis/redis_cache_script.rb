require "redis"
require "../_raw_data/raw_data_provider.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"


redis = Redis.new
threadManager = ThreadManager.new 
testRunner = TestRunner.new 

thread_count = 15  # number of threads trying to excecute concurrently

testRunner.run("insert #{thread_count} random files") do 

	threadManager.config_for_text(thread_count, RawDataProvider, :web_markup) do |x|  
		key_name = "cache_#{Time.now.to_i}-#{Random.rand.to_s[2, 16]}"
		redis.set(key_name, x)	
	end

end

