require "redis"
require "../_raw_data/raw_data_provider.rb"
require "../_utilities/thread_manager.rb"


redis = Redis.new
threadManager = ThreadManager.new 

thread_count = 15  # number of threads trying to excecute concurrently

experiment_count = 10   # number of experiments == number of elements in time_array

time_array = []   # tasks duration -> for posterior analisys

experiment_count.times do |time|
	start_time = Time.now
	threadManager.config_for_text(thread_count, RawDataProvider, :web_markup) do |x|  
		key_name = "cache_#{Time.now.to_i}-#{Random.rand.to_s[2, 16]}"
		redis.set(key_name, x)	
	end
	end_time = Time.now

	task_duration = end_time - start_time
	time_array << task_duration

	puts "It takes #{task_duration} to excecute #{thread_count} random insertions"
end

puts time_array.join(";")
