require 'rails_helper'

RSpec.describe 'Merchant invoice Show page' do
    it 'displays id/status/created_at/customer_name ' do
        merchant = Merchant.create!(name: 'amazon')
        customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
        item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
        invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)
        invoice_2 = Invoice.create!(status: 'in progress', customer_id: customer.id)

        InvoiceItem.create!(quantity: 2, unit_price: 12345, status: 'shipped', item: item_1, invoice: invoice_1)
        InvoiceItem.create!(quantity: 2, unit_price: 12345, status: 'shipped', item: item_1, invoice: invoice_2)

        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        within "#invoice-details" do
            expect(page).to have_content(invoice_1.id)
            expect(page).to have_content('completed')
            expect(page).to have_content(invoice_1.created_at.strftime("%A, %B %d, %Y"))
            expect(page).to have_content("Billy Bob")

            expect(page).to_not have_content(invoice_2.id)
            expect(page).to_not have_content('in progress')
        end
    end

    it 'displays item name/quantity/price/invoice_item status ' do
        merchant = Merchant.create!(name: 'amazon')
        merchant_2 = Merchant.create!(name: 'Gucci')
        customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
        item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
        item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)
        item_3 = Item.create!(name: 'bay blade', description: 'let it rip!', unit_price: 23400, merchant_id: merchant_2.id)
        invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)
        invoice_2 = Invoice.create!(status: 'in progress', customer_id: customer.id)

        InvoiceItem.create!(quantity: 2121, unit_price: 12345, status: 'shipped', item: item_1, invoice: invoice_1)
        InvoiceItem.create!(quantity: 234, unit_price: 2353456, status: 'packaged', item: item_2, invoice: invoice_1)
        InvoiceItem.create!(quantity: 2345, unit_price: 2353, status: 'packaged', item: item_3, invoice: invoice_1)
        InvoiceItem.create!(quantity: 321, unit_price: 3254, status: 'shipped', item: item_1, invoice: invoice_2)

        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        within "#item-details" do
            expect(page).to have_content('pet rock')
            expect(page).to have_content("2121")
            expect(page).to have_content("$123.45")
            expect(page).to have_content("shipped")

            expect(page).to_not have_content('bay blade')
        end
    end

    it 'shows total revenue generated from all items on invoice' do
        merchant = Merchant.create!(name: 'amazon')
        customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
        item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
        item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)
        invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

        InvoiceItem.create!(quantity: 2, unit_price: 1100, status: 'shipped', item: item_1, invoice: invoice_1)
        InvoiceItem.create!(quantity: 10, unit_price: 50000, status: 'packaged', item: item_2, invoice: invoice_1)

        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        within "#invoice-details" do
            expect(page).to have_content("Total Revenue: $5,022.00")
        end
        # <p> Total Revenue: <%= number_to_currency(@facade.merchant.total_revenue(@facade.invoice.id).to_f/100 ) %> </p>
    end

    it 'has a select field to update the item status ' do
        merchant = Merchant.create!(name: 'amazon')
        customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
        item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
        invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)


        InvoiceItem.create!(quantity: 2, unit_price: 11, status: 'shipped', item: item_1, invoice: invoice_1)

        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        within "#item-details" do
            expect(page).to have_content("shipped")
            select "packaged", :from => "status"
            click_on("Update Item Status")
            expect(current_path).to eq("/merchants/#{merchant.id}/invoices/#{invoice_1.id}")
            expect(page).to have_content("packaged")
        end
    end

    # US 6
    # Merchant Invoice Show Page: Total Revenue and Discounted Revenue
    # As a merchant
    # When I visit my merchant invoice show page
    # Then I see the total revenue for my merchant from this invoice (not including discounts)
    # And I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation
    it 'shows total discounted revenue generated from all items on invoice' do
        merchant = Merchant.create!(name: 'amazon')
        
        customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

        item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
        item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)

        invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

        InvoiceItem.create!(quantity: 2, unit_price: 5000, status: 'shipped', item: item_1, invoice: invoice_1)
        InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'packaged', item: item_2, invoice: invoice_1)

        discount_1a = merchant.discounts.create!(discount: 20, threshold: 10)
        discount_1b = merchant.discounts.create!(discount: 30, threshold: 15)

        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        within "#invoice-details" do
            expect(page).to have_content("Total Discounted Revenue: $1,150.00")
        end
    end

    # US 7 
    # Merchant Invoice Show Page: Link to applied discounts
    # As a merchant
    # When I visit my merchant invoice show page
    # Next to each invoice item I see a link to the show page for the bulk discount that was applied (if any)
    it 'has a link to the show page for the discounts applied' do 
        merchant = Merchant.create!(name: 'amazon')
        
        customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')

        item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
        item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)

        invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)

        InvoiceItem.create!(quantity: 10, unit_price: 5000, status: 'shipped', item: item_1, invoice: invoice_1)
        InvoiceItem.create!(quantity: 15, unit_price: 10000, status: 'packaged', item: item_2, invoice: invoice_1)

        discount_1a = merchant.discounts.create!(discount: 20, threshold: 10)
        discount_1b = merchant.discounts.create!(discount: 30, threshold: 15)

        visit "/merchants/#{merchant.id}/invoices/#{invoice_1.id}"

        within "#invoice-details" do
            expect(page).to have_link('20.0% off Discount with Threshold of 10 Applied')
            expect(page).to have_link('30.0% off Discount with Threshold of 15 Applied')
        end
    end
end