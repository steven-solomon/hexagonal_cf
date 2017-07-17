require 'spec_helper'

describe ViewCart do
  let(:cart_repo) {double(:cart_repo, add: nil, fetch: nil, clear: nil)}

  it 'returns the cart' do
    user_id = 1
    cart = double(:cart)
    allow(cart_repo).to receive(:fetch).with(user_id).and_return(cart)

    viewer = ViewCart.new(cart_repo)

    expect(viewer.cart(user_id)).to eq(cart)
  end

  it_should_behave_like 'cart_repo' do
    let(:repo) {cart_repo}
  end
end