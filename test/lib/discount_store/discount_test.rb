# frozen_string_literal: true

require 'minitest/autorun'
require './lib/discount_store/discount'

describe DiscountStore::Discount do
  subject { DiscountStore::Discount.new(type, *args) }

  describe 'constructor' do
    describe 'when the type is invalid' do
      let(:type) { :invalid }
      let(:args) { [0, 0] }

      it 'raises an exception' do
        expect { _(subject) }.must_raise DiscountStore::Discount::InvalidType
      end
    end

    describe 'when the type is valid' do
      let(:type) { :amount }
      let(:args) { [1_500, 3] }

      it 'initialises with a type' do
        _(subject.instance_variable_get(:@type)).must_be_instance_of Proc
      end
    end
  end

  describe 'calculate_for' do
    describe 'when the discount is of type amount' do
      let(:type)  { :amount }
      let(:args)  { [13_000, 3] }
      let(:qty)   { 7 }
      let(:price) { 5_000 }

      it 'computes the discount' do
        _(subject.calculate_for(qty, price)).must_equal 4_000
      end
    end

    describe 'when the discount is of type percent' do
      let(:type)  { :percent }
      let(:args)  { [10, 3] }
      let(:qty)   { 7 }
      let(:price) { 2_000 }

      it 'computes the discount' do
        _(subject.calculate_for(qty, price)).must_equal 1_400
      end
    end
  end
end
