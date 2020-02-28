# frozen_string_literal: true

require './discount_store/checkout'

module DiscountStore
  RULES = {
    item_a: PricingRule.new(5_000),
    item_b: PricingRule.new(3_000),
    item_c: PricingRule.new(2_000),
    item_d: PricingRule.new(1_500)
  }.freeze
end
