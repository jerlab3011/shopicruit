require 'test/unit'
require 'bigdecimal'
require_relative 'product'

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
