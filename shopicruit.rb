require 'open-uri'
require 'json'
require 'bigdecimal'
require 'test/unit'

class Product
    attr_accessor :id, :title, :handle, :body_html, :published_at, :created_at,
    :updated_at, :vendor, :product_type, :tags, :variants, :images, :options

    def initialize(hash)
        hash.each { |key, value| public_send("#{key}=", value)}
        @variants = @variants.map { |variant_hash| Variant.new(variant_hash) }
    end
    
    def cost_of_all_variants
      total = BigDecimal.new(0)
      @variants.each do |variant|
        total += BigDecimal.new(variant.price) unless !variant.available
      end
      total
    end
end

class Variant
    attr_accessor :id, :title, :option1, :option2, :option3, :sku,
    :requires_shipping, :taxable, :featured_image, :available, :price, :grams,
    :compare_at_price, :position,:product_id, :created_at, :updated_at
    def initialize(hash)
        hash.each { |key, value| public_send("#{key}=", value)}
    end
end

page = 1
total = BigDecimal.new(0)
products = []

#Read the json and create products
begin
    uri = "http://shopicruit.myshopify.com/products.json?page="+page.to_s
    page_content = open(uri).read
    data = JSON.parse(page_content)
    current_page_products = data['products'].map { |product_hash| Product.new(product_hash)}
    products += current_page_products
    page += 1
end until current_page_products.empty?

#choose types and print costs of all variants
types = ["Clock", "Watch"] #Change this to change the types you're looking for
products = products.select { |p| types.include?(p.product_type) }
products.each { |product| total += product.cost_of_all_variants }
puts '$'+ "%.2f" % total

class ProductTest < Test::Unit::TestCase
  def setup
    @product = Product.new({"product_type"=>"Clock",
    "variants"=>[{"available"=> true, "price" => "1.50"},
    {"available" => true, "price" => "2.25"}]})
  end

  def test_cost_of_all_variants
    answer = BigDecimal.new("3.75")
    assert_equal(answer, @product.cost_of_all_variants)
  end
end
