class AddProductToCart
  def initialize(repo)
    @repo = repo
  end

  def add(user_id, product_id)
    @repo.add(user_id, product_id)
  end
end