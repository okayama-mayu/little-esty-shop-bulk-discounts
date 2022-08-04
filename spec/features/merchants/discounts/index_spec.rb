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

    discount_1a = merchant_1.discounts.create!(discount: 0.20, threshold: 10)

    binding.pry 

    visit merchant_discounts_path(merchant_1) 


  end

  # And each bulk discount listed includes a link to its show page
end