# pg_cache_insertion_script.rb
# require 'nokogiri'
require 'pg'
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

[false, true].each do |do_hash|

	sufix = ""
	if do_hash
		sufix = "_with_hash_index"
	end
	# params
    magnitude_order = (ARGV[0] || 1).to_i  # number of threads trying to excecute concurrently
	# classes required
	threadManager = ThreadManager.new 
	testRunner = TestRunner.new 
    data_providers = DataLoader.relational_factory magnitude_order

	queries = [:users, :projects, :project_users, :tasks, :columns]
    targets = [:users, :projects, :project_users, :tasks, :columns]

	testRunner.run("read magnitude:#{magnitude_order} pg#{sufix}-rows") do |t|
        threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
        	if query == queries[0]
				PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db") do |conn|
					conn.send_query( "select * from task#{sufix} where assigned_to = ?" , [query_data[0]] ) 
				end
			end
		end
	end
end




 # queries = [
 #        "INSERT INTO users#{sufix} (id, first_name, last_name, email, password_hash, password_salt, active, deleted) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)", 
 #        "INSERT INTO projects#{sufix} (id, name, description, created_by, active) VALUES ($1, $2, $3, $4, $5)", 
 #        "INSERT INTO user_project#{sufix} (id, user_id, project_id, admin) VALUES ($1, $2, $3, $4)", 
 #        "INSERT INTO task#{sufix} (id, name, description, difficulty, created_by, assigned_to, column_id, priority, seconds_worked, completed_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
 #        "INSERT INTO colun#{sufix} (id, name, description, color, orden, project_id) VALUES ($1, $2, $3, $4, $5, $6)"
 #     ]