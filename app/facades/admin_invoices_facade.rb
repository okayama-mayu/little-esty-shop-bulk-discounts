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
    binding.pry 
  end
end