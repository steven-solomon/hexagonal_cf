class ActiveRecordScoreRepo
  def find_all
    Score.all
  end

  def find_by(score_id)
    Score.find(score_id)
  end

  def purchased_content(score_id)
    purchased_content = PurchasedContent.find_by(score_id: score_id)
    purchased_content&.content || ''
  end
end