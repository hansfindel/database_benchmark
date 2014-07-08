# gem install 'cql-rb'
require 'cql'
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"


client = Cql::Client.connect(hosts: ['127.0.0.1'])
client.use('project_manager')

magnitude_order = (ARGV[0] || 1).to_i  # number of threads trying to excecute concurrently
threadManager = ThreadManager.new 
testRunner = TestRunner.new     
data_providers = DataLoader.relational_factory magnitude_order


queries = [:users, :projects, :project_users, :tasks, :columns]
targets = [:users, :projects, :project_users, :tasks, :columns]

# statement = client.prepare('SELECT * FROM task WHERE assigned_to = ?')
# conn.send_query( "select * from task#{sufix} where assigned_to = ?" , [query_data[0]] ) 
testRunner.run("read magnitude:#{magnitude_order} cassandra-rows") do |t|
    threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
      if query == queries[0]
        # arrya = statement.execute(query_data[0])
        arrya = client.execute("SELECT * FROM task WHERE assigned_to = #{query_data[0]} ALLOW FILTERING")
      end
    end
end

client.close

# queries = [
#     "INSERT INTO users (id, first_name, last_name, email, password_hash, password_salt, active, deleted) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", 
#     "INSERT INTO projects (id, name, description, created_by, active) VALUES (?, ?, ?, ?, ?)", 
#     "INSERT INTO user_project (id, user_id, project_id, admin) VALUES (?, ?, ?, ?)", 
#     "INSERT INTO task (id, name, description, difficulty, created_by, assigned_to, column_id, priority, seconds_worked, completed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
#     "INSERT INTO colun (id, name, description, color, orden, project_id) VALUES (?, ?, ?, ?, ?, ?)"
# ]