require 'rails_helper' 

RSpec.describe 'Merchant Discounts Index Page', type: :feature do 
  # Merchant Bulk Discounts Index
  # in spec/features/merchants/dashboard_spec.rb: 
    # As a merchant
    # When I visit my merchant dashboard
    # Then I see a link to view all my discounts
    # When I click this link
    # Then I am taken to my bulk discounts index page

  # Where I see all of my bulk discounts including their
  # percentage discount and quantity thresholds
  it 'displays all of the discounts including their percentage discount and quantity thresholds' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
    merchant_2 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 0.20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 0.30, threshold: 15)

    discount_2a = merchant_2.discounts.create!(discount: 0.15, threshold: 10)
    discount_2b = merchant_2.discounts.create!(discount: 0.30, threshold: 20)

    visit merchant_discounts_path(merchant_1)

    within('#discount-0') do 
      expect(page).to have_content('Discount 1')
      expect(page).to have_content('Discount Amount: 20 percent, Threshold: 10 items')
    end
    
    within('#discount-1') do 
      expect(page).to have_content('Discount 2')
      expect(page).to have_content('Discount Amount: 30 percent, Threshold: 15 items')
    end

    expect(page).to_not have_content('Discount Amount: 15 percent, Threshold: 10 items')
    expect(page).to_not have_content('Discount Amount: 30 percent, Threshold: 20 items')
  end

  # And each bulk discount listed includes a link to its show page
  it 'displays the bulk discounts as links to their show page' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 0.20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 0.30, threshold: 15)

    visit merchant_discounts_path(merchant_1)
    click_link "Discount 1"

    expect(current_path).to eq "/discounts/#{discount_1a.id}"
  end
end