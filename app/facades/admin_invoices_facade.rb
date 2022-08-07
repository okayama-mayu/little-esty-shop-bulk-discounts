class AdminInvoicesFacade
  attr_reader :invoice 

  def initialize(params)
    @invoice = Invoice.find(params[:id])
  end

  def customer_name
    "#{@invoice.customer.first_name} #{@invoice.customer.last_name}"
  end
end