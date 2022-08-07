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

  it 'returns the total discounts' do 
    merchant = Merchant.create!(name: 'amazon')
        
    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
    item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)

    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

    InvoiceItem.create!(quantity: 15, unit_price: 5000, status: 'shipped', item: item_1, invoice: invoice_1)
    InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'packaged', item: item_2, invoice: invoice_1)

    discount_1a = merchant.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant.discounts.create!(discount: 30, threshold: 15)

    params = {
      :merchant_id => merchant.id, 
      :id => invoice_1.id 
    }

    mif = MerchantInvoicesFacade.new(params)
    
    expect(mif.total_discounts).to eq 675.0
  end

  it 'returns the discounted total revenue' do 
    merchant = Merchant.create!(name: 'amazon')
        
    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
    item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)

    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

    InvoiceItem.create!(quantity: 15, unit_price: 5000, status: 'shipped', item: item_1, invoice: invoice_1)
    InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'packaged', item: item_2, invoice: invoice_1)

    discount_1a = merchant.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant.discounts.create!(discount: 30, threshold: 15)

    params = {
      :merchant_id => merchant.id, 
      :id => invoice_1.id 
    }

    mif = MerchantInvoicesFacade.new(params)
    
    expect(mif.discounted_rev).to eq 1575.0
  end

  it 'returns the discount stats' do 
    merchant = Merchant.create!(name: 'amazon')
        
    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

    item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
    item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)

    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

    InvoiceItem.create!(quantity: 10, unit_price: 5000, status: 'shipped', item: item_1, invoice: invoice_1)
    InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'packaged', item: item_2, invoice: invoice_1)

    discount_1a = merchant.discounts.create!(discount: 20, threshold: 10)
    discount_1b = merchant.discounts.create!(discount: 30, threshold: 15)

    params = {
      :merchant_id => merchant.id, 
      :id => invoice_1.id 
    }

    mif = MerchantInvoicesFacade.new(params)

    expect(mif.discount_stats).to eq({
      discount_1a.id.to_s => '20.0% off Discount with Threshold of 10 Applied', 
      discount_1b.id.to_s => '30.0% off Discount with Threshold of 15 Applied'
    })
  end
end