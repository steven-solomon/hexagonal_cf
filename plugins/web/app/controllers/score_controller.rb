class ScoreController < ApplicationController
  def show
    user_id = 1
    found_score = score_finder.find(params[:id].to_i, user_id)
    @score = ScorePresenter.new(found_score)
  end

  def score_finder
    FindScore.new(score_repo, user_repo)
  end

  def user_repo
    ActiveRecordUserRepo.new
  end

  def score_repo
    ActiveRecordScoreRepo.new
  end
end