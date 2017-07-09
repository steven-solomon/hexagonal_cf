require 'rspec'

shared_examples_for 'score_repo' do
  it 'responds to find_all' do
    expect(repo).to respond_to(:find_all)
  end

  it 'responds to find_by' do
    expect(repo).to respond_to(:find_by).with(1).argument
  end

  it 'responds to purchased_content' do
    expect(repo).to respond_to(:purchased_content).with(1).argument
  end
end