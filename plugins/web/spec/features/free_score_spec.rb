require 'rails_helper'

feature 'anonymous user' do
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
    click 'Free Score'
    expect(page).to have_content('Cost: Free')

    click 'Add to Cart'
    expect(page).to have_content('1 Item')
    expect(page).to have_content('Free Score')
  end

  def and_I_checkout
    click 'Checkout'
    expect(page).to have_content('Total: Free')

    click 'Complete'
  end

  def then_I_see_the_score
    expect(page).to have_content('Free Score')
    expect(find('.score-container')).to be_truthy
  end
end