class PurchasedScore
  def initialize(score, purchased_content)
    @score = score
    @purchased_content = purchased_content
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

  attr_reader :purchased_content

  def purchased
    yield purchased_content
  end

  def un_purchased

  end

  def ==(other)
    id == other.id &&
        purchased_content == other.purchased_content &&
        title == other.title &&
        price == other.price
  end
end