# frozen_string_literal: true

module DiscountStore
  class PricingRule # :nodoc:
    def initialize(base_price, discount = nil)
      @base_price = base_price
      @discount   = discount
    end

    def price_for(quantity)
      quantity * base_price - discount&.calculate_for(quantity, base_price).to_i
    end

    private

    attr_reader :base_price, :discount
  end
end
