# run instructions: ruby example.rb

# require 'rubygems'  # not necessary for Ruby 1.9
# require 'couchrest'

require "./couch.rb" 
require "JSON"

server = Couch::Server.new("localhost", "5984")

# server.delete("/foo")

# create a database 
# db = server.get("/foo")
# puts db.body
# server.put("/foo/", "")


doc = <<-JSON
{"type":"comment #{Time.now.to_i}","body":"First Post!"}
JSON
document_id = "document_#{Time.now.to_i}"
server.put("/foo/#{document_id}", doc)

puts "##################################"

res = server.get("/foo/#{document_id}")
json = res.body
puts json


puts "##################################"

db = server.get("/foo/")
puts db.body
