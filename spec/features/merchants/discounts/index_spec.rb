require 'rails_helper' 

RSpec.describe 'Merchant Discounts Index Page', type: :feature do 
  # US 1
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

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    discount_2a = merchant_2.discounts.create!(discount: 15, threshold: 10)
    discount_2b = merchant_2.discounts.create!(discount: 30, threshold: 20)

    visit merchant_discounts_path(merchant_1)

    within('#discount-0') do 
      expect(page).to have_content('Discount 1')
      expect(page).to have_content('Discount Amount: 20.0 percent, Threshold: 10 items')
    end
    
    within('#discount-1') do 
      expect(page).to have_content('Discount 2')
      expect(page).to have_content('Discount Amount: 30.0 percent, Threshold: 15 items')
    end

    expect(page).to_not have_content('Discount Amount: 15.0 percent, Threshold: 10 items')
    expect(page).to_not have_content('Discount Amount: 30.0 percent, Threshold: 20 items')
  end

  # And each bulk discount listed includes a link to its show page
  it 'displays the bulk discounts as links to their show page' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 0.20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 0.30, threshold: 15)

    visit merchant_discounts_path(merchant_1)
    click_link "Discount 1"

    expect(current_path).to eq "/merchants/#{merchant_1.id}/discounts/#{discount_1a.id}"
  end

  # US 2
  # Merchant Bulk Discount Create
  # As a merchant
  # When I visit my bulk discounts index
  # Then I see a link to create a new discount
  # When I click this link
  # Then I am taken to a new page where I see a form to add a new bulk discount
  it 'has a link to create a new Discount' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit merchant_discounts_path(merchant_1)
    click_link 'Create New Discount'

    expect(current_path).to eq "/merchants/#{merchant_1.id}/discounts/new"
  end

  # US3
  # Merchant Bulk Discount Delete
  # As a merchant
  # When I visit my bulk discounts index
  # Then next to each bulk discount I see a link to delete it
  # When I click this link
  # Then I am redirected back to the bulk discounts index page
  # And I no longer see the discount listed
  it 'has a link to delete each Discount' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit merchant_discounts_path(merchant_1)
    
    within('#discount-0') do 
      click_link 'Delete Discount' 
    end

    expect(current_path).to eq "/merchants/#{merchant_1.id}/discounts"
    expect(page).to have_content 'Discount has been successfully deleted.' 
    expect(page).to_not have_content 'Discount Amount: 20.0 percent, Threshold: 10 items'
  end

  # US 9
  # As a merchant
  # When I visit the discounts index page
  # I see a section with a header of "Upcoming Holidays"
  # In this section the name and date of the next 3 upcoming US holidays are listed.
  # Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)
  # https://date.nager.at/api/v3/NextPublicHolidays/US
  it 'has a Holidays section with the next 3 upcoming US holidays' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    visit merchant_discounts_path(merchant_1)
    save_and_open_page
    
    within('#holidays') do 
      expect(page).to have_content "Upcoming Holidays"
      expect(page).to have_content "Labor Day: 2022-09-05" 
      expect(page).to have_content "Veterans Day: 2022-11-11" 
      expect(page).to have_content "Thanksgiving Day: 2022-11-24" 
    end
  end 

  # Extension 1 
  # When an invoice is pending, a merchant should not be able to delete or edit a bulk discount that applies to any of their items on that invoice.
  it 'does not allow a Discount to be deleted if the Merchant has a pending Invoice' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
    item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

    InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 'shipped', item: item_1, invoice: invoice_1)
    InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'packaged', item: item_2, invoice: invoice_1)

    visit merchant_discounts_path(merchant_1)
    
    within('#discount-1') do 
      click_link 'Delete Discount' 
    end

    expect(current_path).to eq "/merchants/#{merchant_1.id}/discounts"
    expect(page).to have_content 'Merchant has one or more Pending Invoices. Discount cannot be deleted when an Invoice is pending.'
    expect(page).to have_content('Discount Amount: 15.0 percent, Threshold: 30 items')
  end
end