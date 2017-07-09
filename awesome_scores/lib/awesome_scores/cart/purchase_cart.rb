class PurchaseCart
  def initialize(cart_repo, user_repo)
    @cart_repo = cart_repo
    @user_repo = user_repo
  end

  def purchase(user_id)
    cart = cart_repo.fetch(user_id)
    purchase_scores(user_id, cart)
    cart_repo.clear(user_id)
  end

  private

  def purchase_scores(user_id, cart)
    cart.scores.each do |score|
      user_repo.add_purchase(user_id, score.id) if is_free?(score)
    end
  end

  def is_free?(score)
    score.price == 0
  end

  attr_accessor :user_repo, :cart_repo
end