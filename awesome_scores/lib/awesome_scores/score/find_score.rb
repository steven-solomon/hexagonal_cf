class FindScore
  def initialize(score_repo, user_repo)
    @score_repo = score_repo
    @user_repo = user_repo
  end

  def find_all
    @score_repo.find_all
  end

  def find(score_id, user_id)
    if (purchased?(user_id, score_id))
      purchased_content = @score_repo.purchased_content(score_id)
      PurchasedScore.new(@score_repo.find_by(score_id), purchased_content)
    else
      UnPurchasedScore.new(@score_repo.find_by(score_id))
    end
  end

  private

  def purchased?(user_id, score_id)
    @user_repo.purchases(user_id).any? { |score| score.id == score_id }
  end
end