class AdminInvoicesFacade
  attr_reader :invoice 

  def initialize(params)
    @invoice = Invoice.find(params[:id])
  end
end