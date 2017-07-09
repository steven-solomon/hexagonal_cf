require 'rails_helper'

describe ActiveRecordUserRepo do
  let(:user_repo) {ActiveRecordUserRepo.new}

  it 'adding a purchase will allow user to have purchase' do
    user_id = 1
    score_id = 11112

    user_repo.add_purchase(user_id, score_id)

    purchases = user_repo.purchases(user_id)

    expect(purchases.length).to eq(1)
    expect(purchases.first.score_id).to eq(score_id)
  end

  it_should_behave_like 'user_repo' do
    let(:repo) {user_repo}
  end
end