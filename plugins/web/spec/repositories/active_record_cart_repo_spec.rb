require 'rails_helper'

describe ActiveRecordCartRepo do

  let(:user_id) {1}

  let!(:score) {Score.create(title: 'Score Title', price: 1000)}

  let(:cart_repo) {ActiveRecordCartRepo.new}

  before do
    cart_repo.add(user_id, score.id)
    @cart = cart_repo.fetch(user_id)
  end

  it 'saves and retrieves a cart' do
    expect(@cart.scores.length).to eq(user_id)
    expect(@cart.scores.first).to eq(score)
  end

  describe '#clear' do
    it 'clears the cart' do
      cart_repo.clear(user_id)

      cart = cart_repo.fetch(user_id)

      expect(cart.scores).to be_empty
    end

    it 'does not clear the cart of other users' do
      other_user_id = 2
      cart_repo.add(other_user_id, score.id)

      cart_repo.clear(user_id)

      cart = cart_repo.fetch(other_user_id)

      expect(cart.scores.length).to eq(user_id)
      expect(cart.scores.first).to eq(score)
    end
  end

  it_should_behave_like 'cart_repo' do
    let(:repo) {cart_repo}
  end
end