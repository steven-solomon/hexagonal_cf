require 'rails_helper'

feature 'anonymous user' do
  before do
    Score.create(price: 0, title: 'Free Score')
  end

  scenario 'can buy a free score' do
    given_I_am_on_the_homepage
    when_I_add_the_free_score_to_my_cart
    and_I_checkout
    then_I_see_the_score
  end

  def given_I_am_on_the_homepage
    visit '/'
  end

  def when_I_add_the_free_score_to_my_cart
    click_on 'Free Score'

    expect(find('[data-title]')).to have_content('Free Score')
    expect(find('[data-price]')).to have_content('Free')
    expect(page).not_to have_css('.score-container')

    click_on 'Add to Cart'

    expect(find('[data-items-count]')).to have_content('1')
    expect(find('[data-score-title]')).to have_content('Free Score')
    expect(find('[data-score-price]')).to have_content('Free')
    expect(find('[data-total]')).to have_content('Free')
  end

  def and_I_checkout
    click_on 'Checkout'

    expect(find('#complete')).to be_truthy
  end

  def then_I_see_the_score
    first('.score').click

    expect(page).to have_content('Free Score')
    expect(find('.score-container')).to be_truthy
  end
end