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

  def self.find(id)
    file = File.dirname(__FILE__) + "/../data/data.csv"
    data = CSV.read(file)
    data.shift
    data.each do |row|
      return self.create(id: row[0], brand: row[1], name: row[2], price: row[3]) if row[0].to_i == id
    end
  end

  def self.find_by_brand(brand_name)
    self.all.each do |product|
      return product if product.brand == brand_name 
    end
  end

  def self.find_by_name(product_name)
    self.all.each do |product|
      return product if product.name == product_name
    end
  end

  def self.where(options={})
    brand = options[:brand]
    name = options[:name]

    if brand != nil
      self.all.select { |product| product.brand == brand }
    elsif name != nil
      self.all.select { |product| product.name == name }
    end
  end

  def self.destroy(id)
    file = File.dirname(__FILE__) + "/../data/data.csv"
    data = CSV.read(file)
    header = data.shift

    data.each do |row|
      if row[0].to_i == id
        deleted_obj = self.create(id: row[0], brand: row[1], name: row[2], price: row[3])
        data.delete(row)
        write_to_file(file, header, data)
        return deleted_obj
      end
    end
  end

  def self.write_to_file(file, header, data)
    CSV.open(file, "wb") do |csv|
      csv << header
    end

    data.each do |row|
      CSV.open(file, "ab") do |csv|
        csv << row
      end
    end
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
