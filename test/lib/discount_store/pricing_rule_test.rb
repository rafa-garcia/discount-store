# frozen_string_literal: true

require 'minitest/autorun'
require './lib/discount_store/pricing_rule'

describe DiscountStore::PricingRule do
  subject { DiscountStore::PricingRule }

  describe 'constructor' do
    describe 'when called with no arguments' do
      it 'raises an exception' do
        expect { subject.new }.must_raise ArgumentError
      end
    end

    describe 'when called with arguments' do
      describe 'and it is only the price' do
        let(:price) { 5_000 }

        it 'has a base price' do
          instance = subject.new(price)
          _(instance).must_be_instance_of subject
          _(instance.instance_variable_get(:@base_price)).must_equal 5_000
        end

        it 'does not have a discount' do
          instance = subject.new(price)
          _(instance).must_be_instance_of subject
          _(instance.instance_variable_get(:@discount)).must_be_nil
        end
      end

      describe 'and it is price and discount' do
        let(:price) { 5_000 }
        let(:discount) { :discount }

        it 'has a base price' do
          instance = subject.new(price, discount)
          _(instance).must_be_instance_of subject
          _(instance.instance_variable_get(:@base_price)).must_equal 5_000
        end

        it 'has a discount' do
          instance = subject.new(price, discount)
          _(instance).must_be_instance_of subject
          _(instance.instance_variable_get(:@discount)).must_equal :discount
        end
      end
    end
  end

  describe 'price_for' do
    describe 'when there is no discount' do
      let(:price) { 5_000 }

      it 'returns the price for quantity' do
        instance = subject.new(price)
        _(instance.price_for(5)).must_equal 25_000
      end
    end

    describe 'when there is a discount' do
      let(:price) { 5_000 }
      let(:discount) { Minitest::Mock.new }

      it 'returns the price for quantity with discount' do
        discount.expect :calculate_for, 2_000, [3, 5_000]

        instance = subject.new(price, discount)
        _(instance.price_for(3)).must_equal 13_000
        assert_mock discount
      end
    end
  end
end
