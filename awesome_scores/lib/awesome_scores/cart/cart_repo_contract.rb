require 'rspec'

shared_examples_for 'cart_repo' do
  it 'responds to add' do
    expect(repo).to respond_to(:add).with(2).arguments
  end

  it 'responds to fetch' do
    expect(repo).to respond_to(:fetch).with(1).argument
  end

  it 'responds to clear' do
    expect(repo).to respond_to(:clear).with(1).argument
  end
end