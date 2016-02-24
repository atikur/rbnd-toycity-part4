require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  def self.create(options={})
    file = File.dirname(__FILE__) + "/../data/data.csv"
    existing_contents = CSV.read(file)
    
    obj = self.new(options)

    if (obj.is_a? Product)
      new_record = [obj.id, obj.brand, obj.name, obj.price]
      if !existing_contents.include?(new_record)
      	CSV.open(file, "ab") do |csv|
      	  csv << new_record
      	end
      end
    end
    obj
  end
end
