# pg_cache_insertion_script.rb
# require 'nokogiri'
require 'pg'
require "../_raw_data/structured_data_provider.rb"
require "../_utilities/thread_manager.rb"
require "../_utilities/test_runner.rb"

[false, true].each do |do_hash|
    sufix = ""
    if do_hash
        sufix = "_with_hash_index"
    end

    conn=PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db")
    conn.exec_params("DROP TABLE IF EXISTS users#{sufix}") # should skip this if doesn't exist
    conn.exec_params("CREATE TABLE users#{sufix} (
        id INTEGER, 
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        password_hash VARCHAR(50) NOT NULL,
        password_salt VARCHAR(50) NOT NULL,
        active BOOLEAN, 
        deleted BOOLEAN)" );
    conn.exec_params("CREATE INDEX email_hash ON users#{sufix} (email)") if do_hash
    conn.close
    puts "created users#{sufix}"

    conn=PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db")
    conn.exec_params("DROP TABLE IF EXISTS projects#{sufix}") # should skip this if doesn't exist
    conn.exec_params("CREATE TABLE projects#{sufix} (
        id INTEGER, 
        name VARCHAR(50) NOT NULL,
        description TEXT,
        organization_id INTEGER NOT NULL,
        created_by INTEGER NOT NULL,
        active BOOLEAN)" );
    conn.exec_params("CREATE INDEX projects_name_hash ON projects#{sufix} (name)") if do_hash
    conn.exec_params("CREATE INDEX projects_created_by_hash ON projects#{sufix} (created_by)") if do_hash
    conn.exec_params("CREATE INDEX projects_active_hash ON projects#{sufix} (active)") if do_hash
    conn.close
    puts "created projects#{sufix}"

    conn=PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db")
    conn.exec_params("DROP TABLE IF EXISTS user_project#{sufix}") # should skip this if doesn't exist
    conn.exec_params("CREATE TABLE user_project#{sufix} (
        id INTEGER, 
        user_id INTEGER NOT NULL,
        project_id INTEGER NOT NULL,
        admin BOOLEAN)" );
    conn.exec_params("CREATE INDEX user_project_user_id_hash ON user_project#{sufix} (user_id)") if do_hash
    conn.exec_params("CREATE INDEX user_project_project_id_hash ON user_project#{sufix} (project_id)") if do_hash
    conn.close
    puts "created user_project#{sufix}"

    conn=PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db")
    conn.exec_params("DROP TABLE IF EXISTS task#{sufix}") # should skip this if doesn't exist
    conn.exec_params("CREATE TABLE task#{sufix} (
        id INTEGER, 
        name VARCHAR(50) NOT NULL,
        description TEXT NOT NULL,
        difficulty INTEGER,
        created_by INTEGER NOT NULL,
        assigned_to INTEGER NOT NULL,
        column_id INTEGER NOT NULL,
        priority FLOAT NOT NULL,
        seconds_worked INTEGER NOT NULL,
        completed_at TIMESTAMP NOT NULL)" );
    conn.exec_params("CREATE INDEX task_name_hash ON task#{sufix} (name)") if do_hash
    conn.exec_params("CREATE INDEX task_created_by_hans ON task#{sufix} (created_by)") if do_hash
    conn.exec_params("CREATE INDEX task_assigned_to_hans ON task#{sufix} (assigned_to)") if do_hash
    conn.exec_params("CREATE INDEX task_column_id_hans ON task#{sufix} (column_id)") if do_hash
    conn.close
    puts "created task#{sufix}"

    conn=PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db")
    conn.exec_params("DROP TABLE IF EXISTS colun#{sufix}") # should skip this if doesn't exist
    conn.exec_params("CREATE TABLE colun#{sufix} (
        id INTEGER, 
        name VARCHAR(50) NOT NULL,
        description TEXT NOT NULL,
        color VARCHAR(25) NOT NULL,
        orden INTEGER NOT NULL, 
        project_id INTEGER NOT NULL)" );
    conn.exec_params("CREATE INDEX colun_name_hash ON colun#{sufix} (name)") if do_hash
    conn.exec_params("CREATE INDEX colun_project_id_hash ON colun#{sufix} (project_id)") if do_hash
    conn.close
    puts "created column#{sufix}"

    puts "database created"
    # params
    repetitions_per_document = (ARGV[0] || 3).to_i  # number of threads trying to excecute concurrently
    # classes required
    threadManager = ThreadManager.new 
    testRunner = TestRunner.new 
    data_providers = StructuredDataProvider.factory

    testRunner.run("insert #{repetitions_per_document} pg#{sufix}-rows") do |t|
        threadManager.map(repetitions_per_document, data_providers, :getName, :getHTML) do |name, html|  
            PGconn.connect( hostaddr: "127.0.0.1", port: 5432, dbname: "pg_example_db") do |conn|
                # key_name = "cached_#{name}_#{t}"
                # conn.exec_params( "INSERT INTO mycaches#{sufix} (name, html) VALUES ($1, $2)", [key_name, html] )
                # insertion work... 
            end
        end
    end
end

# conn.close

# more concurrent connections! -> http://stackoverflow.com/questions/14049185/postgresql-evolutions-psqlexception-fatal-sorry-too-many-clients-already 