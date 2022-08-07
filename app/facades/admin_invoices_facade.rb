class AdminInvoicesFacade
  attr_reader :invoice 

  def initialize(params)
    @invoice = Invoice.find(params[:id])
  end

  def customer_name
    "#{@invoice.customer.first_name} #{@invoice.customer.last_name}"
  end

  def total_revenue
    @invoice.total_revenue.to_f
  end

  def total_discounts
    @invoice.all_discounts.sum do |invoice_item|
      invoice_item.item_discount
    end
  end

  def discounted_revenue
    total_revenue - total_discounts
  end
end