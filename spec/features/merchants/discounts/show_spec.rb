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

    expect(page).to have_content('Quantity Threshold: 10')
    expect(page).to have_content('Percentage Discount: 20.0%')

    expect(page).to_not have_content('Quantity Threshold: 15')
    expect(page).to_not have_content('Percentage Discount: 30.0%')
  end

  # US 5
  # Merchant Bulk Discount Edit
  # As a merchant
  # When I visit my bulk discount show page
  # Then I see a link to edit the bulk discount
  # When I click this link
  # Then I am taken to a new page with a form to edit the discount
  it 'has a link to edit the bulk discount' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit merchant_discount_path(merchant_1, discount_1b)
    click_link 'Edit Discount'

    expect(current_path).to eq "/merchants/#{merchant_1.id}/discounts/#{discount_1b.id}/edit"
  end
end