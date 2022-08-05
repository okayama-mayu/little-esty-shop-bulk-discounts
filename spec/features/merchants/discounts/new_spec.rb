require 'rails_helper' 

RSpec.describe 'New Merchant Discount page' do 
  # US 2 
  # Merchant Bulk Discount Create
  # in spec/features/merchants/discounts/index_spec.rb: 
    # As a merchant
    # When I visit my bulk discounts index
    # Then I see a link to create a new discount
    # When I click this link
    # Then I am taken to a new page where I see a form to add a new bulk discount
  
  # When I fill in the form with valid data
  # Then I am redirected back to the bulk discount index
  # And I see my new bulk discount listed
  it 'has a form that can create a new Discount' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit new_merchant_discount_path(merchant_1)

    fill_in 'Discount Rate', with: 35 
    fill_in 'Threshold', with: 20 
    click_on 'Create Discount' 
    save_and_open_page

    expect(current_path).to eq merchant_discounts_path(merchant_1)
    
    expect(page).to have_content "Merchant Discount was successfully added."

    within('#discount-2') do 
      expect(page).to have_content('Discount 3')
      expect(page).to have_content('Discount Amount: 35.0 percent, Threshold: 20 items')
    end
  end

  xit 'returns to the form with an alert if the form is not correctly filled in' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit new_merchant_discount_path(merchant_1)

    fill_in 'Discount Rate', with: abc 
    fill_in 'Threshold', with: twenty
    click_on 'Create Discount' 
    
    expect(page).to have_content "Error: Please fill in all fields with numbers."
  end
end