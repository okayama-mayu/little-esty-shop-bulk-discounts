class MerchantInvoicesFacade
  attr_reader :merchant, :invoice  

  def initialize(params)
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
  end

  def total_discounts
    discounts = @invoice.all_discounts.map do |invoice_item|  
      invoice_item.item_discount
    end

    discounts.sum
  end
end