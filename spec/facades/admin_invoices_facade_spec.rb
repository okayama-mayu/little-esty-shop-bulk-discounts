require 'rails_helper' 

RSpec.describe 'Admin Invoices Facade', type: :facade do 
  before :each do 
    Faker::UniqueGenerator.clear 
    
    @merchant_1 = Merchant.create!(name: Faker::Company.unique.name)
    
    @customer_1 = Customer.create!(first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name)
    
    @item_1 = Item.create!( name: Faker::Commerce.unique.product_name, 
                            description: 'Our first test item', 
                            unit_price: rand(100..10000), 
                            merchant_id: @merchant_1.id)

    @item_2 = Item.create!( name: Faker::Commerce.unique.product_name, 
                            description: 'Our second test item', 
                            unit_price: rand(100..10000), 
                            merchant_id: @merchant_1.id)
    
    @invoice_1 = Invoice.create!( status: 'completed', 
                                customer_id: @customer_1.id)

    @invoice_item_1 = InvoiceItem.create!(quantity: 1, unit_price: 5000, status: 'shipped', item_id: @item_1.id, invoice_id: @invoice_1.id)
    @invoice_item_2 = InvoiceItem.create!(quantity: 5, unit_price: 10000, status: 'shipped', item_id: @item_2.id, invoice_id: @invoice_1.id)
    
    @discount_1a = @merchant_1.discounts.create!(discount: 20, threshold: 2)
    @discount_1b = @merchant_1.discounts.create!(discount: 10, threshold: 5) # should never get applied 
    
    @params = {
      :id => @invoice_1.id 
    }

    @aif = AdminInvoicesFacade.new(@params)
  end
  
  it 'has an Invoice' do 
    expect(@aif.invoice).to eq @invoice_1
  end

  it 'returns the customers full name' do 
    expect(@aif.customer_name).to eq "#{@customer_1.first_name} #{@customer_1.last_name}"
  end

  it 'returns the Total Revenue' do
    expect(@aif.total_revenue).to eq 550.0
  end

  it 'returns the Total Discount' do 
    expect(@aif.total_discounts).to eq 100.0
  end

  it 'returns the Total Discounted Revenue' do 
    expect(@aif.discounted_revenue).to eq 450.0 
  end
end