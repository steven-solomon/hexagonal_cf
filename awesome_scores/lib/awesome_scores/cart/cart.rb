class Cart
  def initialize(scores)
    @scores = scores
  end

  def total
    @scores.reduce(0) do |sum, score|
      sum + score.price
    end
  end

  def items_count
    @scores.length
  end

  attr_reader :scores
end