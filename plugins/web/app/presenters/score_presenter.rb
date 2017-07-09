class ScorePresenter < SimpleDelegator
  include PricePresenter

  protected

  def value
    price
  end
end