require 'spec_helper'

describe AddProductToCart do
  let(:user_id) {2}
  let(:score_id) {1}
  let(:cart_repo) {double(:cart_repo, add: nil, fetch: nil, clear: nil)}
  let(:product_adder) {AddProductToCart.new(cart_repo)}

  it 'updates cart for user' do
    product_adder.add(user_id, score_id)

    expect(cart_repo).to have_received(:add).with(user_id, score_id)
  end

  it_should_behave_like 'cart_repo' do
    let(:repo) { cart_repo }
  end
end