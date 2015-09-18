# After the upgrade to Mongoid, the object-ids are no longer strings, as
# described here: http://mongoid.org/docs/upgrading.html (look for UPGRADING TO 2.0.0.BETA.11 +)
#
# As a one time operation, we can convert all _id that are of type string, to BSON::ObjectId
# This script has to be run in the Rails environment, please use :
#
#     rails runner lib/tasks/convert_mongo_strings_to_objectids.rb
#
require 'mongoid'

# Stop writing to your database.
# Then, for each collection:
# Specify the COLLECTIONS you want to convert.
COLLECTIONS = ["devry_anesthesia"] # Put a list of collection names here

def convert_ids(obj)
  if obj.is_a?(String) && obj =~ /^[a-f0-9]{24}$/
    BSON::ObjectId(obj)
  elsif obj.is_a?(Array)
    obj.map do |v|
      convert_ids(v)
    end
  elsif obj.is_a?(Hash)
    obj.each do |k, v|
      obj[k] = convert_ids(v)
    end
  else
    obj
  end
end

def convert_collection collection
  original_collection = @db[collection]
  new_collection = @db['new_' + collection]
  #new_collection.drop

  original_collection.find({}, :timeout => false, :sort => "_id") do |c|
    c.each do |doc|
      new_doc = convert_ids(doc)
      new_collection.insert(new_doc, :safe => true)
    end
  end

  puts "rename the collections"
  original_collection_name = original_collection.name
  original_collection.rename("#{original_collection_name}_original")
  new_collection.rename("#{original_collection_name}")

  puts "Converted #{collection}"
end

puts "Start conversion ..."

DB = "ada_development"
@con = Mongo::Connection.new
@db = @con[DB]

COLLECTIONS.each do |collection|
  convert_collection collection
end