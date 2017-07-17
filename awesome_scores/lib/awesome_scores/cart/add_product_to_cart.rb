class AddProductToCart
  def initialize(repo)
    @repo = repo
  end

  def add(user_id, score_id)
    @repo.add(user_id, score_id)
  end
end