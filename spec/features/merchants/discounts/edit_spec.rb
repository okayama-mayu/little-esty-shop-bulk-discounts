require 'rails_helper' 

RSpec.describe 'Merchant Discount Edit Page', type: :feature do 
  # US 5
  # Merchant Bulk Discount Edit
  # in spec/features/merchants/discounts/show_spec: 
    # As a merchant
    # When I visit my bulk discount show page
    # Then I see a link to edit the bulk discount
    # When I click this link
    # Then I am taken to a new page with a form to edit the discount

  # And I see that the discounts current attributes are pre-populuated in the form
  it 'has pre-populated entries in the form' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit edit_merchant_discount_path(merchant_1, discount_1b)

    expect(page).to have_field('Number of an Item that must be bought to trigger the discount:', with: discount_1b.threshold) 
    expect(page).to have_field('Percentage Discount:', with: discount_1b.discount) 

    expect(page).to_not have_field('Number of an Item that must be bought to trigger the discount:', with: discount_1a.threshold) 
    expect(page).to_not have_field('Percentage Discount:', with: discount_1a.discount) 
  end

  # When I change any/all of the information and click submit
  # Then I am redirected to the bulk discount's show page
  # And I see that the discount's attributes have been updated
  it 'can update a Discount and redirect to the Discount Show page' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit edit_merchant_discount_path(merchant_1, discount_1b)

    fill_in 'Number of an Item that must be bought to trigger the discount:', with: '20'
    fill_in 'Percentage Discount:', with: '30.5' 
    click_on 'Update Discount Information' 

    expect(current_path).to eq "/merchants/#{merchant_1.id}/discounts/#{discount_1b.id}"
    expect(page).to have_content "Discount has been successfully updated."
    expect(page).to have_content 'Quantity Threshold: 20'
    expect(page).to have_content 'Percentage Discount: 30.5%'
  end

  it 'is redirected to the Edit page if the form is not filled out correctly' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit edit_merchant_discount_path(merchant_1, discount_1a)

    fill_in 'Number of an Item that must be bought to trigger the discount:', with: ''
    fill_in 'Percentage Discount:', with: 'forty' 
    click_on 'Update Discount Information' 

    expect(current_path).to eq "/merchants/#{merchant_1.id}/discounts/#{discount_1a.id}/edit"
    expect(page).to have_content "Error: Discount was not updated. Please fill out the form using numbers."
  end
end