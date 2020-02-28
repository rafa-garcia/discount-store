# frozen_string_literal: true

require './lib/discount_store/checkout'
require './lib/discount_store/discount'
require './lib/discount_store/pricing_rule'

module DiscountStore # :nodoc:
  # Discount system simulation with the following pricing rules, in cents:
  # - 3 of 'item_a' for 13,000
  # - 2 of 'item_b' for 4,500
  # - 10% discount for 3+ of 'item_c'
  # Usage:
  # basket = DiscountStore.basket
  # 5.times { basket.add('item_c') }
  # 4.times { basket.add('item_a') }
  # 3.times { basket.add('item_b') }
  # 2.times { basket.add('item_d') }
  # basket.total # => 37500

  RULES = {
    item_a: PricingRule.new(5_000, Discount.new(:amount, 13_000, 3)),
    item_b: PricingRule.new(3_000, Discount.new(:amount, 4_500, 2)),
    item_c: PricingRule.new(2_000, Discount.new(:percent, 10, 3)),
    item_d: PricingRule.new(1_500)
  }.freeze

  def self.basket(rules = RULES)
    Checkout.new(rules)
  end
end
