require "redis"
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

# params
magnitude_order = (ARGV[0] || 1).to_i  # number of threads trying to excecute concurrently

# classes required
redis = Redis.new
threadManager = ThreadManager.new 
testRunner = TestRunner.new 

queries = ["users", "projects", "tasks", "columns"]
targets = [:users, :projects, :tasks, :columns]

# data required && the script itself
data_providers = DataLoader.nested_keyvalue_factory magnitude_order
testRunner.run("insert #{magnitude_order} files in redis") do |t|
	threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
		key_name = "#{query}_#{query_data[:id]}_#{t}"
		redis.set(key_name, query_data)	
		# puts key_name # tasks_1305_0
	end
end
