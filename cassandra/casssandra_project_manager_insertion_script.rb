# gem install 'cql-rb'
require 'cql'
require "../_utilities/data_loader.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"


client = Cql::Client.connect(hosts: ['127.0.0.1'])


keyspace_destruction = <<-KSDEF
  DROP KEYSPACE IF EXISTS project_manager
KSDEF
keyspace_definition = <<-KSDEF
  CREATE KEYSPACE project_manager
  WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
  }
KSDEF
client.execute(keyspace_destruction)
client.execute(keyspace_definition)
client.use('project_manager')


table_definition1 = <<-TABLEDEF
  CREATE TABLE users (
  	id bigint, 
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    password_hash VARCHAR,
    password_salt VARCHAR,
    active BOOLEAN,
    deleted BOOLEAN,
    PRIMARY KEY (id)
  )
TABLEDEF
table_definition2 = <<-TABLEDEF
  CREATE TABLE projects (
  	id bigint, 
    name VARCHAR,
    description TEXT,
    created_by bigint,
    active BOOLEAN,
    PRIMARY KEY (id)
  )
TABLEDEF
table_definition3 = <<-TABLEDEF
  CREATE TABLE user_project (
  	id bigint, 
    user_id bigint,
	project_id bigint,
	admin BOOLEAN,
    PRIMARY KEY (id)
  )
TABLEDEF
table_definition4 = <<-TABLEDEF
  CREATE TABLE task (
  	id bigint, 
    name VARCHAR,
    description TEXT,
    difficulty bigint,
    created_by bigint,
    assigned_to bigint,
    column_id bigint,
	priority double,
	seconds_worked bigint,
	completed_at bigint,
    PRIMARY KEY (id)
  )
TABLEDEF


table_definition5 = <<-TABLEDEF
  CREATE TABLE colun (
  	id bigint, 
    name VARCHAR,
    description TEXT,
    color VARCHAR,
    orden bigint,
    project_id bigint, 
    PRIMARY KEY (id)
  )
TABLEDEF

client.execute(table_definition1)
puts "created users"
client.execute(table_definition2)
puts "created projects"
client.execute(table_definition3)
puts "created user_project"
client.execute(table_definition4)
puts "created task"
client.execute(table_definition5)
puts "created column"

# client.create_index()
# client.close
puts "database created"



magnitude_order = (ARGV[0] || 1).to_i  # number of threads trying to excecute concurrently
threadManager = ThreadManager.new 
testRunner = TestRunner.new     
data_providers = DataLoader.relational_factory magnitude_order

queries = [
    "INSERT INTO users (id, first_name, last_name, email, password_hash, password_salt, active, deleted) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", 
    "INSERT INTO projects (id, name, description, created_by, active) VALUES (?, ?, ?, ?, ?)", 
    "INSERT INTO user_project (id, user_id, project_id, admin) VALUES (?, ?, ?, ?)", 
    "INSERT INTO task (id, name, description, difficulty, created_by, assigned_to, column_id, priority, seconds_worked, completed_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
    "INSERT INTO colun (id, name, description, color, orden, project_id) VALUES (?, ?, ?, ?, ?, ?)"
]
targets = [:users, :projects, :project_users, :tasks, :columns]

testRunner.run("insert magnitude:#{magnitude_order} cassandra-rows") do |t|
    threadManager.project_manager_map(data_providers, queries, targets) do |query, query_data|  
    	# client.execute("INSERT INTO casscaches (name, html) VALUES (?,?)",  key_name, html)
    	# client.execute(query, query_data)
  		# Cql::Client.connect(hosts: ['127.0.0.1']) do |client|
		# client.use('project_manager')

    	if query_data.size == 4
    		client.execute(query, query_data[0], query_data[1], query_data[2], query_data[3])
    	elsif query_data.size == 5
    		client.execute(query, query_data[0], query_data[1], query_data[2], query_data[3], query_data[4])
    	elsif query_data.size == 6
    		client.execute(query, query_data[0], query_data[1], query_data[2], query_data[3], query_data[4], query_data[5])
    	elsif query_data.size == 8
    		client.execute(query, query_data[0], query_data[1], query_data[2], query_data[3], query_data[4], query_data[5], query_data[6], query_data[7])
		elsif query_data.size == 10    		
			client.execute(query, query_data[0], query_data[1], query_data[2], query_data[3], query_data[4], query_data[5], query_data[6], query_data[7], query_data[8], query_data[9])
    	end
    	# puts [query, query_data].join("-_-")

    	# end #do client 
    end
end

client.close