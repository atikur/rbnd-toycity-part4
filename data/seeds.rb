require 'faker'

# This file contains code that populates the database with
# fake data for testing purposes

def db_seed
  file = File.dirname(__FILE__) + "/../data/data.csv"

  (1..21).each do |i|
    CSV.open(file, "ab") do |csv|
      csv << [i, Faker::Company.name, Faker::Commerce.product_name, Faker::Commerce.price]
    end
  end
end
