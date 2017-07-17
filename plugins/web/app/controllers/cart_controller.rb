class CartController < ApplicationController
  def update
    user_id = 1
    add_product_to_cart.add(user_id, cart_params[:score_id])
    @cart = CartPresenter.new(view_cart.cart(user_id))
  end

  def add_product_to_cart
    AddProductToCart.new(repo)
  end

  def cart_params
    params.permit(:score_id)
  end

  def repo
    ActiveRecordCartRepo.new
  end

  def view_cart
    ViewCart.new(repo)
  end
end