# gem install 'cql-rb'
require 'cql'

client = Cql::Client.connect(hosts: ['127.0.0.1'])

keyspace_definition = <<-KSDEF
  CREATE KEYSPACE measurements
  WITH replication = {
    'class': 'SimpleStrategy',
    'replication_factor': 1
  }
KSDEF

table_definition = <<-TABLEDEF
  CREATE TABLE events (
    id INT,
    comment VARCHAR,
    PRIMARY KEY (id)
  )
TABLEDEF

# did not like the Date dataType
# table_definition = <<-TABLEDEF
#   CREATE TABLE events (
#     id INT,
#     date DATE,
#     comment VARCHAR,
#     PRIMARY KEY (id)
#   )
# TABLEDEF

client.execute(keyspace_definition)
client.use('measurements')
client.execute(table_definition)


client.close
