require 'bigdecimal'
require_relative 'variant'

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
