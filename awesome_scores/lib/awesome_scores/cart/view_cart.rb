class ViewCart
  def initialize(repo)
    @repo = repo
  end

  def get_cart(user_id)
    @repo.fetch(user_id)
  end
end