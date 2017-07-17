require 'spec_helper'

describe PurchaseCart do
  # I decided to lookup the cart because we don't want to complicate the
  # api for purchasing a cart for a user. In addition we don't want to allow
  # client code to buy a cart that isn't persisted in the cart repo.
  let(:user_id) {1}
  let(:score_id) {12131}
  let(:score) {StubScore.new(score_id, 0)}
  let(:cart_for_user) {Cart.new([score])}

  let(:user_repo) {double(:user_repo, add_purchase: nil, purchases: nil)}
  let(:cart_repo) {double(:cart_repo, clear: nil, fetch: nil, add: nil)}
  let(:sut) {PurchaseCart.new(cart_repo, user_repo)}

  it 'add product to user and clear cart' do
    allow(cart_repo).to receive(:fetch).with(user_id).and_return(cart_for_user)

    sut.purchase(user_id)

    expect(user_repo).to have_received(:add_purchase).with(user_id, score_id).ordered
    expect(cart_repo).to have_received(:clear).with(user_id).ordered
  end

  context 'when score#price is not free' do
    let(:score) {StubScore.new(score_id, 100)}

    it 'is not added to the user' do
      allow(cart_repo).to receive(:fetch).with(user_id).and_return(cart_for_user)

      sut.purchase(user_id)

      expect(user_repo).not_to have_received(:add_purchase).with(user_id, score_id)
      expect(cart_repo).to have_received(:clear).with(user_id)
    end
  end

  class StubScore
    def initialize(id, price)
      @id = id
      @price = price
    end

    attr_reader :id, :price
  end

  it_should_behave_like 'user_repo' do
    let(:repo) { user_repo }
  end

  it_should_behave_like 'cart_repo' do
    let(:repo) { cart_repo }
  end
end