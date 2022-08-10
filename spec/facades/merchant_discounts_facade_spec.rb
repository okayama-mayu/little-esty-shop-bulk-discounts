require 'rails_helper' 

RSpec.describe 'MerchantDiscountsFacade', type: :facade do 
  it 'has a Merchant' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    params = {
      :controller =>"merchant_discounts", 
      :action =>"show", 
      :merchant_id => merchant_1.id.to_s
    } 

    mdf = MerchantDiscountsFacade.new(params)
    expected = Merchant.find(params[:merchant_id])

    expect(mdf.merchant).to eq expected 
  end

  it 'has Discounts' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    params = {
      :controller =>"merchant_discounts", 
      :action =>"show", 
      :merchant_id => merchant_1.id.to_s
    } 

    mdf = MerchantDiscountsFacade.new(params)
    expected = merchant_1.discounts 

    expect(mdf.discounts).to eq expected 
  end

  it 'can return a string with the Discount amount and threshold' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    params = {
      :controller =>"merchant_discounts", 
      :action =>"show", 
      :merchant_id => merchant_1.id.to_s
    } 

    mdf = MerchantDiscountsFacade.new(params)

    expected = ["Discount Amount: #{discount_1a.discount} percent, Threshold: #{discount_1a.threshold} items", "Discount Amount: #{discount_1b.discount} percent, Threshold: #{discount_1b.threshold} items" ]

    expect(mdf.discounts_display).to eq expected
  end

  it 'returns a specific Discount' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    params = {
      :controller =>"merchant_discounts", 
      :action =>"show", 
      :merchant_id => merchant_1.id.to_s, 
      :id => discount_1a.id.to_s 
    } 

    mdf = MerchantDiscountsFacade.new(params)

    expect(mdf.discount).to eq discount_1a
  end

  it 'returns the next 3 US holidays' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    params = {
      :controller =>"merchant_discounts", 
      :action =>"show", 
      :merchant_id => merchant_1.id.to_s, 
      :id => discount_1a.id.to_s 
    } 

    mdf = MerchantDiscountsFacade.new(params)

    expect(mdf.next_3_holidays).to eq(["Labor Day: 2022-09-05", "Veterans Day: 2022-11-11", "Thanksgiving Day: 2022-11-24"])
  end

  it 'returns false if it is attached to a pending Invoice' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant_1.id)
    item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant_1.id)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    invoice_1 = Invoice.create!(status: 'in progress', customer_id: customer.id)

    InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 'pending', item: item_1, invoice: invoice_1)
    InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'pending', item: item_2, invoice: invoice_1)

    params = {
      :controller =>"merchant_discounts", 
      :action =>"destroy", 
      :merchant_id => merchant_1.id.to_s, 
      :id => discount_1b.id.to_s 
    } 

    mdf = MerchantDiscountsFacade.new(params)

    expect(mdf.discount_deletable?).to eq false 
  end

  it 'returns true if it is NOT attached to a pending Invoice' do 
    Faker::UniqueGenerator.clear 
    merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

    item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant_1.id)
    item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant_1.id)

    discount_1a = merchant_1.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant_1.discounts.create!(discount: 30, threshold: 15)

    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

    InvoiceItem.create!(quantity: 10, unit_price: 5000, status: 'shipped', item: item_1, invoice: invoice_1)
    InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'shipped', item: item_2, invoice: invoice_1)

    params = {
      :controller =>"merchant_discounts", 
      :action =>"destroy", 
      :merchant_id => merchant_1.id.to_s, 
      :id => discount_1b.id.to_s 
    } 

    mdf = MerchantDiscountsFacade.new(params)

    expect(mdf.discount_deletable?).to eq true 
  end
end