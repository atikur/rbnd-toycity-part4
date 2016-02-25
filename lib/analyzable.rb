module Analyzable

  def print_report(products)
    report = "Average Price: $#{average_price(products).to_s}\n"
    report += "Inventory by Brand:\n"

    count_by_brand(products).each do |brand, count|
      report += "\t- #{brand}: #{count}\n"
    end

    report += "Inventory by Name:\n"
    count_by_name(products).each do |name, count|
      report += "\t- #{name}: #{count}\n"
    end
    report
  end

  def average_price(products)
    total_price = products.inject(0) do |sum, product|
      sum + product.price.to_f
    end
    (total_price/products.length).round(2)
  end
  
  def count_by_brand(products)
    brand_products = {}

    products.each do |product|
      if brand_products[product.brand]
        brand_products[product.brand] += 1
      else
        brand_products[product.brand] = 1
      end
    end
    brand_products
  end

  def count_by_name(products)
    products_count = {}

    products.each do |product|
      if products_count[product.name]
        products_count[product.name] += 1
      else
        products_count[product.name] = 1
      end
    end
    products_count
  end

end
