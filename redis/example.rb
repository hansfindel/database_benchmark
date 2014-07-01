require "redis"

redis = Redis.new

redis.set("mykey", "hello world")
# => "OK"

puts redis.get("mykey")
# => "hello world"

###################################
###################################

require "json"

redis.set "foo", [1, 2, 3].to_json
# => OK

puts JSON.parse(redis.get("foo"))
# => [1, 2, 3]

#lists
redis.lpush('mylist', 'a')
# => 1
redis.lpush('mylist', 'b')
# => 2
redis.rpush('mylist', 'c')
# => 3
redis.lrange("mylist",0,2)
# => ["b", "a", "c"]

## async
pipe = redis.pipelined do
  redis.set "foo", "bar"
  redis.incr "baz"
end
puts pipe 
# => ["OK", 1]


## "async" with storing data
multi = redis.multi do
  redis.set "foo", "bar"
  redis.incr "baz"
end
puts multi
# => ["OK", 1]

# display all available keys
puts redis.keys.join(", ")
