class UnPurchasedScore
  def initialize(score)
    @score = score
  end

  def purchased_content
    ''
  end

  def id
    @score.id
  end

  def title
    @score.title
  end

  def price
    @score.price
  end

  def purchased
    # no op
  end

  def un_purchased
    yield
  end

  def ==(other)
    id == other.id &&
        purchased_content == other.purchased_content &&
        title == other.title &&
        price == other.price
  end
end
