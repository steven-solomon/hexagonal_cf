class CheckoutController < ApplicationController
  def create
    user_id = 1
    @purchased_scores = view_cart.get_cart(user_id).scores
    purchase_cart.purchase(user_id)
  end

  def view_cart
    ViewCart.new(cart_repo)
  end

  def purchase_cart
    PurchaseCart.new(cart_repo, user_repo)
  end

  def cart_repo
    ActiveRecordCartRepo.new
  end

  def user_repo
    ActiveRecordUserRepo.new
  end
end