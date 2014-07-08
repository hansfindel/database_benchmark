require "redis"
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"
require "json"

# params
magnitude_order = (ARGV[0] || 1).to_i  # number of threads trying to excecute concurrently

# classes required
redis = Redis.new
threadManager = ThreadManager.new 
testRunner = TestRunner.new 

queries = [:users, :projects, :tasks, :columns]
targets = [:users, :projects, :tasks, :columns]

# data required && the script itself
data_providers = DataLoader.nested_keyvalue_factory magnitude_order
testRunner.run("read #{magnitude_order} files in redis") do |t|
	threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
		if query == queries[0]
			user_key = "#{query.to_s}_#{query_data[:id]}_#{t}"
			# user = JSON.parse(redis.get(user_key))
			# proj_ids = user[:project_ids]
			user = redis.get(user_key).to_s
			proj_ids = user[user.rindex("project_id").to_i+14..-3].to_s.split(",")
			proj_ids.each do |p_id|
				proj_key = "projects_#{p_id}_#{t}"
				# proj = JSON.parse(redis.get(proj_key))
				proj = redis.get(proj_key).to_s
				# puts proj
				
				cols_ids = proj[proj.rindex(":columns=>").to_i+9..-3].to_s.split(",")
				cols_ids.each do |col_id|
					col_key = "columns_#{col_id}_#{t}"
					col = redis.get(col_key).to_s
					# puts col
					task_ids = col[col.rindex(":tasks=>").to_i+9..-3].to_s.split(",")
					task_ids.each do |task_id|
						task_key = "tasks_#{task_id}_#{t}"
						task = redis.get(task_key).to_s
					end
				end
			end
			# JSON.parse(redis.get("foo"))
			# puts key_name # tasks_1305_0
		end
	end
end
