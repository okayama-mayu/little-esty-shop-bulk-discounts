require 'rails_helper' 

RSpec.describe 'Merchant Discount Show page', type: :feature do 
  # US4
  # Merchant Bulk Discount Show
  # As a merchant
  # When I visit my bulk discount show page
  # Then I see the bulk discount's quantity threshold and percentage discount
  it 'shows the discount quantity threshold and percentage discount' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit merchant_discount_path(merchant_1, discount_1a)
    save_and_open_page

    expect(page).to have_content('Quantity Threshold: 10')
    expect(page).to have_content('Percentage Discount: 20.0%')
  end
end