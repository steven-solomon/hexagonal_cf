require 'spec_helper'

describe FindScore do
  let(:score) {double(:score, id: 1, purchased_content: '', title: '', price: 0)}
  let(:score_repo) {double(:score_repo, find_all: score, find_by: nil, purchased_content: nil)}
  let(:user_repo) {double(:user_repo, add_purchase: nil, purchases: nil)}

  describe '#find_all' do
    it 'returns all scores' do
      score_finder = FindScore.new(score_repo, user_repo)

      result = score_finder.find_all

      expect(result).to eq(score)
    end
  end

  describe '#find' do
    context 'when score has not been purchases' do
      let(:user_id) {10}

      before do
        allow(user_repo).to receive(:purchases).with(user_id).and_return([])
      end

      it 'returns single score' do
        score_finder = FindScore.new(score_repo, user_repo)
        allow(score_repo).to receive(:find_by).with(score.id).and_return(score)

        result = score_finder.find(score.id, user_id)

        expect(result).to eq(score)
      end
    end

    context 'when score has purchases' do
      let(:user_id) {10}
      let(:purchased_content) { 'purchase only available content' }

      before do
        allow(user_repo).to receive(:purchases).with(user_id).and_return([score])
      end

      it 'returns single score' do
        purchased_score = double(:purchased_score, id:score.id, purchased_content: purchased_content, title: '', price: 0)

        score_finder = FindScore.new(score_repo, user_repo)
        allow(score_repo).to receive(:find_by).with(score.id).and_return(score)
        allow(score_repo).to receive(:purchased_content).with(score.id).and_return(purchased_content)

        result = score_finder.find(score.id, user_id)
        expect(result).to eq(purchased_score)
      end
    end
  end

  it_should_behave_like 'score_repo' do
    let(:repo) {score_repo}
  end

  it_should_behave_like 'user_repo' do
    let(:repo) {user_repo}
  end
end