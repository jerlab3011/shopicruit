class Variant
    attr_accessor :id, :title, :option1, :option2, :option3, :sku,
    :requires_shipping, :taxable, :featured_image, :available, :price, :grams,
    :compare_at_price, :position,:product_id, :created_at, :updated_at
    def initialize(hash)
        hash.each { |key, value| public_send("#{key}=", value)}
    end
end
