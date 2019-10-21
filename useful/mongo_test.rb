require 'mongo'

class MongoHelper

  # TODO replace with yours
  COLLECTION = 'sk_gazetteer'


  def initialize
	# TODO turn off if needed (default is the lowest level)
	Mongo::Logger.logger.level = ::Logger::ERROR
    @client = Mongo::Client.new(ENV['MONGO_URL'])
    create_index
  end

  # TODO replace
  def create_index
    @client[COLLECTION].indexes.create_one(
      { 'company_name'      => 1,
        'certificate_type'  => 1,
        'city'              => 1,
        'province'          => 1,
        'country'           => 1
       },
      unique: true
    )
  end

  def save(record)
    @client[COLLECTION].insert_one(record)
    @records_saved_n += 1
    true
  rescue Mongo::Error::OperationFailure => e
    # raise
    if e.message =~ /duplicate key error/
      query = {
        'company_name'      => record['company_name'],
        'certificate_type'  => record['certificate_type'],
        'city'              => record['city'],
        'province'          => record['province'],
        'country'           => record['country']
      }
      original_record = find_one(query)
      # update if modified
      if newer?(record['date_retrieved'], original_record['date_retrieved'])
        update_one(original_record, record)
        @records_updated_n += 1
        true
      else
        logger.warn "Ignoring duplicate record: '#{record['company_name']}' "\
          "(#{record['certificate_type']} in #{record['city']}, #{record['province']})."
        false
      end
    else
      raise
    end
  end

  # check if new_date_str is actually later than old_date_str
  def newer?(new_date_str, old_date_str)
    pattern = '%Y-%m-%d'
    DateTime.strptime(new_date_str, pattern) > DateTime.strptime(old_date_str, pattern)
  end

  def find_one(query)
    @client[COLLECTION].find(query).first
  end

  def update_one(original_record, updated_record)
    @client[COLLECTION].find_one_and_replace(original_record, updated_record)
  end

  def close
    @client.close
  end
end
