class ActiveRecordCartRepo
  def add(user_id, score_id)
    CartEntry.create(user_id: user_id, score_id: score_id)
  end

  def fetch(user_id)
    scores = CartEntry.where(user_id: user_id).map(&:score)
    Cart.new(scores)
  end

  def clear(user_id)
    CartEntry.where(user_id: user_id).destroy_all
  end
end