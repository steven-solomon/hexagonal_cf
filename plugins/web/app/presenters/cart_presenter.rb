class CartPresenter < SimpleDelegator
  include PricePresenter

  protected

  def value
    total
  end
end