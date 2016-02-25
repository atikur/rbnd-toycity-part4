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

  def self.all
    file = File.dirname(__FILE__) + "/../data/data.csv"
    data = CSV.read(file)
    data.shift
    data.map! { |row| self.create(id: row[0], brand: row[1], name: row[2], price: row[3]) }
  end

  def self.first(n=1)
    return self.all.first if n == 1
    self.all.first(n)
  end

  def self.last(n=1)
    return self.all.last if n == 1
    self.all.last(n)
  end
end
