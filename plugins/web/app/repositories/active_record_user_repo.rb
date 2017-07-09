class ActiveRecordUserRepo
  def add_purchase(user_id, score_id)
    UserPurchase.create(user_id: user_id, score_id: score_id)
  end

  def purchases(user_id)
    UserPurchase.where(user_id: user_id)
  end
end