# frozen_string_literal: true

module DiscountStore
  class Checkout # :nodoc:
    InvalidItem = Class.new(StandardError)

    def initialize(rules)
      @rules = rules
      @items = Hash.new(0)
    end

    def add(item)
      raise InvalidItem, "item #{item} doesn't exist" unless rules[item]

      items[item] += 1
      self
    end

    def total
      items.inject(0) do |mem, (item, quantity)|
        mem + rules[item].price_for(quantity)
      end
    end

    private

    attr_reader :items, :rules
  end
end
