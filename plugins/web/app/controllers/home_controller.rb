class HomeController < ApplicationController
  def index
    @scores = score_finder.find_all
  end

  def score_finder
    FindScore.new(score_repo, user_repo)
  end

  def score_repo
    ActiveRecordScoreRepo.new
  end

  def user_repo
    ActiveRecordUserRepo.new
  end
end