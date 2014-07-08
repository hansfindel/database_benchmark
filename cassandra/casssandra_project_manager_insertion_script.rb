# gem install 'cql-rb'
require 'cql'


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
  	id INT, 
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
  	id INT, 
    name VARCHAR,
    description TEXT,
    organization_id INT,
    created_by INT,
    active BOOLEAN,
    PRIMARY KEY (id)
  )
TABLEDEF
table_definition3 = <<-TABLEDEF
  CREATE TABLE user_project (
  	id INT, 
    user_id INT,
	project_id INT,
	admin BOOLEAN,
    PRIMARY KEY (id)
  )
TABLEDEF
table_definition4 = <<-TABLEDEF
  CREATE TABLE task (
  	id INT, 
    name VARCHAR,
    description TEXT,
    difficulty INT,
    created_by INT,
    assigned_to INT,
    column_id INT,
	priority FLOAT,
	seconds_worked INT,
	completed_at TIMESTAMP,
    PRIMARY KEY (id)
  )
TABLEDEF

table_definition5 = <<-TABLEDEF
  CREATE TABLE colun (
  	id INT, 
    name VARCHAR,
    description TEXT,
    color VARCHAR,
    orden INT,
    project_id INT, 
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
client.close
puts "database created"
