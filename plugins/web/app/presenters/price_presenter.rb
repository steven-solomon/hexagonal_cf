module PricePresenter
  def formatted_price
    if value == 0
      'Free'
    else
      value
    end
  end
end