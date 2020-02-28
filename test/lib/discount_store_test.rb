# frozen_string_literal: true

require 'minitest/autorun'
require './lib/discount_store'

# Acceptance tests
describe DiscountStore do
  subject { DiscountStore.basket(rules) }

  let(:rules) do
    {
      item_a: DiscountStore::PricingRule.new(
        5_000, DiscountStore::Discount.new(:amount, 13_000, 3)
      ),
      item_b: DiscountStore::PricingRule.new(
        3_000, DiscountStore::Discount.new(:amount, 4_500, 2)
      ),
      item_c: DiscountStore::PricingRule.new(
        2_000, DiscountStore::Discount.new(:percent, 10, 3)
      ),
      item_d: DiscountStore::PricingRule.new(1_500)
    }
  end

  it 'adds items to the basket and computes totals' do
    subject.add(:item_a) # => 5000
    _(subject.total).must_equal 5_000
    subject.add(:item_b) # => 5000 + 3000
    _(subject.total).must_equal 8_000
    subject.add(:item_c) # => 8000 + 2000
    _(subject.total).must_equal 10_000
    subject.add(:item_d) # => 10000 + 1500
    _(subject.total).must_equal 11_500
    subject.add(:item_a) # => 11500 + 5000
    _(subject.total).must_equal 16_500
    subject.add(:item_b) # => 16500 + 1500 (discount 2 x item_b)
    _(subject.total).must_equal 18_000
    subject.add(:item_c) # => 18000 + 2000
    _(subject.total).must_equal 20_000
    subject.add(:item_d) # => 20000 + 1500
    _(subject.total).must_equal 21_500
    subject.add(:item_a) # => 21500 + 3000 (discount 3 x item_a)
    _(subject.total).must_equal 24_500
    subject.add(:item_b) # => 24500 + 3000
    _(subject.total).must_equal 27_500
    subject.add(:item_c) # => 27500 + 1400 (discount 3 x item_c)
    _(subject.total).must_equal 28_900
    subject.add(:item_a) # => 28900 + 5000
    _(subject.total).must_equal 33_900
    subject.add(:item_c) # => 33900 + 1800 (discount 3+ x item_c)
    _(subject.total).must_equal 35_700
    subject.add(:item_c) # => 35700 + 1800 (discount 3+ x item_c)
    _(subject.total).must_equal 37_500
  end
end
