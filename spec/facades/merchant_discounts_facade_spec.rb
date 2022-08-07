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
end