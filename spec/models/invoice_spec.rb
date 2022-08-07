require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status) }
  end

  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }
    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  before :each do

  end

  describe 'class methods' do
    it 'incomplete_invoices lists all invoices with items that have not shipped' do
      merchant = Merchant.create!(name: 'Mike Dao')
      customer = Customer.create!(first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name)
      8.times do
          Item.create!(name: Faker::Beer.name, description: Faker::Beer.style, unit_price: Faker::Number.digit, merchant_id: merchant.id )
      end
      10.times do
          invoice = Invoice.create!(status: Faker::Number.between(from: 0, to: 2), customer_id: customer.id)
          InvoiceItem.create!(invoice_id: invoice.id,quantity: Faker::Number.digit, unit_price: Faker::Number.digit, status: 'pending', item_id: Faker::Number.between(from: Item.first.id, to: Item.last.id))
          InvoiceItem.create!(invoice_id: invoice.id,quantity: Faker::Number.digit, unit_price: Faker::Number.digit, status: 'pending', item_id: Faker::Number.between(from: Item.first.id, to: Item.last.id))
      end
      invoice = Invoice.create!(status: Faker::Number.between(from: 0, to: 2), customer_id: customer.id)
      InvoiceItem.create!(invoice_id: invoice.id,quantity: Faker::Number.digit, unit_price: Faker::Number.digit, status: 'shipped', item_id: Faker::Number.between(from: Item.first.id, to: Item.last.id))

      expect(Invoice.incomplete_invoices.all.count).to eq(10)
      expect(Invoice.incomplete_invoices.all).to_not include(invoice)
    end
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it 'can calculate the total revenue for an invoice' do
        Faker::UniqueGenerator.clear 

        merchant_1 = Merchant.create!(name: Faker::Company.unique.name)

        customer_1 = Customer.create!(
          first_name: Faker::Name.unique.first_name,
          last_name: Faker::Name.unique.last_name)

        invoice_1 = Invoice.create!( status: 'completed', 
                                      customer_id: customer_1.id)

        item_1 = Item.create!(name: Faker::Commerce.unique.product_name, 
                              description: 'Our first test item', 
                              unit_price: rand(100..10000), 
                              merchant_id: merchant_1.id)

        item_2 = Item.create!(name: Faker::Commerce.unique.product_name, 
                              description: 'Our second test item', 
                              unit_price: rand(100..10000), 
                              merchant_id: merchant_1.id)

        invoice_item_1 = InvoiceItem.create!(quantity: 1, 
                                              unit_price: 5000, 
                                              status: 'shipped', 
                                              item_id: item_1.id, 
                                              invoice_id: invoice_1.id)

        invoice_item_2 = InvoiceItem.create!(quantity: 5, 
                                              unit_price: 10000, 
                                              status: 'shipped', 
                                              item_id: item_2.id, 
                                              invoice_id: invoice_1.id)

        expect(invoice_1.total_revenue).to eq(55000)
      end
    end

    describe '#total_discounts' do 
      it 'shows total discount amount generated from all items on invoice' do
        merchant = Merchant.create!(name: 'amazon')
        
        customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

        item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
        item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)

        invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

        InvoiceItem.create!(quantity: 15, unit_price: 50, status: 'shipped', item: item_1, invoice: invoice_1)
        InvoiceItem.create!(quantity: 15, unit_price: 100, status: 'packaged', item: item_2, invoice: invoice_1)

        discount_1a = merchant.discounts.create!(discount: 20, threshold: 10)
        discount_1b = merchant.discounts.create!(discount: 30, threshold: 15)

        expected = invoice_1.total_discounts.map { |invoice_item| invoice_item.item_discount }.sum 

        expect(expected).to eq 450.0 
      end
    end
  end
end
