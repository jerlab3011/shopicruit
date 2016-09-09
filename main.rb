require 'open-uri'
require 'json'
require 'bigdecimal'
require_relative 'product'

page = 1
total = BigDecimal.new(0)
products = []

begin
    uri = "http://shopicruit.myshopify.com/products.json?page="+page.to_s
    page_content = open(uri).read
    data = JSON.parse(page_content)
    current_page_products = data['products'].map { |product_hash| Product.new(product_hash)}
    products += current_page_products
    page += 1
end until current_page_products.empty?

types = ["Clock", "Watch"]
products = products.select { |p| types.include?(p.product_type) }
products.each { |product| total += product.cost_of_all_variants }
puts '$'+total.to_s('F')
