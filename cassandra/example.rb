# possibly good link - singlenode_root 
# http://www.datastax.com/docs/1.0/getting_started/install_singlenode_root

# to start server on local machine, on cassandras bin folder -> sudo ./cassandra 
# enter the cassandra's shell ->  ./cqlsh
# example on local language - CQL (Cassandra Query Language ?)
# cqlsh> create keyspace dev with replication = {'class':'SimpleStrategy','replication_factor':1};
# cqlsh> use dev;
# cqlsh:dev> create table emp (empid int primary key, emp_first varchar, emp_last varchar, emp_dept varchar);
# cqlsh:dev> insert into emp (empid, emp_first, emp_last, emp_dept) values (1,'fred','smith','eng');
# cqlsh:dev> select * from emp;
# cqlsh:dev> update emp set emp_dept = 'fin' where empid = 1;
# cqlsh:dev> select * from emp;

# cqlsh:dev> create index idx_dept on emp(emp_dept);

## based on the example_create_env database
require 'cql'

client = Cql::Client.connect(hosts: ['127.0.0.1'])
client.use('measurements')

# client.execute("INSERT INTO events (id, date, description) VALUES (23462, '2013-02-24T10:14:23+0000', 'Rang bell, ate food')")
client.execute("INSERT INTO events (id, comment) VALUES (23462, 'Rang bell, ate food')")
client.execute("UPDATE events SET comment = 'Oh, my' WHERE id = 13126")

# rows = client.execute('SELECT date, comment FROM events')
rows = client.execute('SELECT id, comment FROM events')
rows.each do |row|
  row.each do |key, value|
    puts "#{key} = #{value}"
  end
end

client.close
