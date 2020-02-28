# frozen_string_literal: true

require './discount_store/checkout'

module DiscountStore
  RULES = {
    item_a: 5_000,
    item_b: 3_000,
    item_c: 2_000,
    item_d: 1_500
  }.freeze
end
