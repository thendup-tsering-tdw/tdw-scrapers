require 'mongo'

# suppress all of the messages if you don't want to keep track of these
Mongo::Logger.logger.level = ::Logger::ERROR

db_name = 'property_assessment'
# client will connect to specific db of mongo instance that you specify in the ENV
#   e.g. in your .bash_profile:
#   export MONGO_URL=mongodb://104.196.100.171:27017/
mongo = Mongo::Client.new("#{ENV['MONGO_URL']}#{db_name}")

# and further scope by collections (aka tables in SQL world)
#collection = 'ivry_sur_le_lac'
collection = 'quebec'

# to create index (composite unique index)
mongo[collection].indexes.create_one(
	{ 'field1' => 1,
	  'field2' => 1
    },
    unique: true)

# to save a single record
record = { 'field1' => 'some content', 'field2' => 'something else' }
mongo[collection].insert_one(record)

# to close a connection to db
mongo.close
