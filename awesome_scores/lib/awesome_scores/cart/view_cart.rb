class ViewCart
  def initialize(repo)
    @repo = repo
  end

  def cart(user_id)
    @repo.fetch(user_id)
  end
end