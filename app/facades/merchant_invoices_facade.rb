class MerchantInvoicesFacade
  attr_reader :merchant, :invoice  

  def initialize(params)
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
  end
end