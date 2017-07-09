require 'spec_helper'

describe Cart do
  let(:cart) {Cart.new(scores)}

  context 'when there are NO score in the cart' do
    let(:scores) {[]}

    it 'calculates total of zero' do
      expect(cart.total).to eq(0)
    end

    it 'has item_count of zero' do
      expect(cart.items_count).to eq(0)
    end
  end

  context 'when there are score in the cart' do
    let(:scores) {[double(:score, price: 5), double(:score, price: 10)]}

    it 'calculates total of ten' do
      expect(cart.total).to eq(15)
    end

    it 'has item_count of two' do
      expect(cart.items_count).to eq(2)
    end
  end
end