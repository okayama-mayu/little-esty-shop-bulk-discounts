require 'rails_helper' 

RSpec.describe 'Merchant Invoices Facade', type: :facade do 
  it 'has a Merchant' do 
    merchant = Merchant.create!(name: 'amazon')
    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

    params = {
      :merchant_id => merchant.id, 
      :id => invoice_1.id 
    }

    mif = MerchantInvoicesFacade.new(params)

    expect(mif.merchant).to eq merchant
  end

  it 'has an Invoice' do 
    merchant = Merchant.create!(name: 'amazon')
    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

    params = {
      :merchant_id => merchant.id, 
      :id => invoice_1.id 
    }

    mif = MerchantInvoicesFacade.new(params)

    expect(mif.invoice).to eq invoice_1
  end
end