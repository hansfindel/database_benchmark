# gem install 'cql-rb'
require 'cql'


client = Cql::Client.connect(hosts: ['127.0.0.1'])


keyspace_destruction1 = <<-KSDEF
  DROP KEYSPACE IF EXISTS cache_measurements
KSDEF
keyspace_destruction2 = <<-KSDEF
  DROP KEYSPACE IF EXISTS measurements
KSDEF

client.execute(keyspace_destruction2)
client.execute(keyspace_destruction1)


# create keyspace & table
keyspace_definition = <<-KSDEF
  CREATE KEYSPACE cache_measurements
  WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
  }
KSDEF
table_definition = <<-TABLEDEF
  CREATE TABLE casscaches (
    name VARCHAR,
    html TEXT,
    PRIMARY KEY (name)
  )
TABLEDEF

client.execute(keyspace_definition)
client.use('cache_measurements')
client.execute(table_definition)

client.close