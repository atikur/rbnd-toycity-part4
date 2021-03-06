require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata

  def update(options={})
    name = options[:name] ? options[:name] : self.name
    brand = options[:brand] ? options[:brand] : self.brand
    price = options[:price] ? options[:price] : self.price

    file = File.dirname(__FILE__) + "/../data/data.csv"
    data = CSV.read(file)
    header = data.shift

    data.each_with_index do |product, index|
      if product[0].to_i == self.id
        data[index] = [self.id, brand, name, price]
        break
      end
    end

    self.class.write_to_file(file, header, data)

    return self.class.create(id: self.id, brand: brand, name: name, price: price)
  end

  def to_s
    @name
  end

  def self.create(options={})
    file = File.dirname(__FILE__) + "/../data/data.csv"
    existing_contents = CSV.read(file)
    
    obj = self.new(options)

    if (obj.is_a? Product)
      new_record = [obj.id.to_s, obj.brand, obj.name, obj.price]
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

    raise ProductNotFoundError, "Product with id #{id} not found."
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

    raise ProductNotFoundError, "Product with id #{id} not found."
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

Module.create_finder_methods("brand", "name")