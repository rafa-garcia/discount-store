# frozen_string_literal: true

require 'minitest/autorun'
require './lib/discount_store/checkout'

describe DiscountStore::Checkout do
  subject { DiscountStore::Checkout }

  let(:rules) do
    {
      item_a: pricing_rule,
      item_b: pricing_rule,
      item_c: pricing_rule,
      item_d: pricing_rule
    }
  end
  let(:pricing_rule) { Minitest::Mock.new }
  let(:invalid_item_error) { DiscountStore::Checkout::InvalidItem }

  describe 'new' do
    describe 'when called with no arguments' do
      it 'raises an exception' do
        expect { subject.new }.must_raise ArgumentError
      end
    end

    describe 'when called with an argument' do
      it 'initialises' do
        _(subject.new(rules)).must_be_instance_of DiscountStore::Checkout
      end
    end
  end

  describe 'add' do
    subject { DiscountStore::Checkout.new(rules) }

    it 'starts off empty' do
      _(subject.instance_variable_get(:@items)).must_be_empty
    end

    describe 'when the item is not known' do
      it 'raises an exception' do
        expect { subject.add(:item_z) }.must_raise invalid_item_error
      end
    end

    describe 'when the item is known' do
      it 'accepts a string' do
        subject.add('item_a')

        _(subject.instance_variable_get(:@items).keys.first)
          .must_be_instance_of Symbol
      end

      it 'accepts a symbol' do
        subject.add(:item_a)

        _(subject.instance_variable_get(:@items).keys.first)
          .must_be_instance_of Symbol
      end

      it 'adds to the items collection' do
        subject.add(:item_a)

        _(subject.instance_variable_get(:@items)[:item_a]).wont_be_nil
      end

      it 'registers the quantities' do
        subject.add(:item_a)
        subject.add(:item_a)
        subject.add(:item_b)

        _(subject.instance_variable_get(:@items)[:item_a]).must_equal 2
        _(subject.instance_variable_get(:@items)[:item_b]).must_equal 1
      end
    end
  end

  describe 'total' do
    subject { DiscountStore::Checkout.new(rules) }

    describe 'when items do not have discount' do
      it 'calculates the sum of prices' do
        5.times { subject.add(:item_d) }
        3.times { subject.add(:item_a) }

        pricing_rule.expect :price_for, 7_500, [5]
        pricing_rule.expect :price_for, 15_000, [3]

        _(subject.total).must_equal 22_500
        assert_mock pricing_rule
      end
    end

    describe 'when items have discount' do
      it 'calculates the discounted prices' do
        3.times { subject.add(:item_a) }
        2.times { subject.add(:item_b) }

        pricing_rule.expect :price_for, 13_000, [3]
        pricing_rule.expect :price_for, 4_500, [2]

        _(subject.total).must_equal 17_500
        assert_mock pricing_rule
      end
    end
  end
end
