# frozen_string_literal: true

module DiscountStore
  class Discount # :nodoc:
    InvalidType = Class.new(StandardError)

    TYPES = {
      amount: lambda do |qty, price, min, rate|
        discounted_qty, non_discounted_qty = qty.divmod(min)
        (qty * price) - (discounted_qty * rate) - (non_discounted_qty * price)
      end,
      percent: lambda do |qty, price, min, rate|
        qty * price * rate / 100 if qty >= min
      end
    }.freeze

    def initialize(type, rate, min)
      @type = TYPES.fetch(type) { raise InvalidType, "'#{type}' not supported" }
      @rate = rate
      @min  = min
    end

    def calculate_for(qty, price)
      @type.call(qty, price, @min, @rate)
    end
  end
end
