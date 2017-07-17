class FindScore
  def initialize(score_repo, user_repo)
    @score_repo = score_repo
    @user_repo = user_repo
  end

  def find_all
    @score_repo.find_all
  end

  def find(score_id, user_id)
    if purchased?(score_id, user_id)
      purchased_content = @score_repo.purchased_content(score_id)
      PurchasedScore.new(@score_repo.find_by(score_id), purchased_content)
    else
      UnPurchasedScore.new(@score_repo.find_by(score_id))
    end
  end

  private

  def purchased?(score_id, user_id)
    purchases = @user_repo.purchases(user_id)
    purchases.any? { |score| score.id == score_id }
  end
end