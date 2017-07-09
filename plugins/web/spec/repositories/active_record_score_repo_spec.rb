require 'rails_helper'

describe ActiveRecordScoreRepo do
  let(:score_repo) {ActiveRecordScoreRepo.new}

  it_should_behave_like 'score_repo' do
    let(:repo) {score_repo}
  end

  context 'when there are NO scores' do
    it 'returns an empty array' do
      expect(score_repo.find_all).to eq([])
    end

    it 'returns purchasable content' do
      random_id = 102
      expect(score_repo.purchased_content(random_id)).to eq('')
    end
  end

  context 'when there are scores' do
    let!(:score_1) {Score.create(price: 0, title: 'Free Score')}
    let!(:score_2) {Score.create(price: 100, title: 'Another Score')}
    let!(:content) {PurchasedContent.create(score_id: score_1.id, content: 'Stuff you must buy.')}

    it 'returns all the score' do
      expect(score_repo.find_all).to contain_exactly(score_1, score_2)
    end

    it 'returns specific score' do
      expect(score_repo.find_by(score_1.id)).to eq(score_1)
    end

    it 'returns purchasable content' do
      expect(score_repo.purchased_content(score_1.id)).to eq('Stuff you must buy.')
    end
  end
end