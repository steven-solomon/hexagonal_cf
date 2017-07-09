require 'rspec'

shared_examples_for 'user_repo' do
  it 'responds to add_purchase' do
    expect(repo).to respond_to(:add_purchase).with(2).arguments
  end

  it 'responds to owns score' do
    expect(repo).to respond_to(:purchases).with(1).argument
  end
end