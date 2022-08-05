class MerchantDiscountsFacade 
  attr_reader :merchant, :discounts

  def initialize(params)
    @params = params 
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def discounts_display 
    @discounts.map do |d| 
      "Discount Amount: #{d.discount} percent, Threshold: #{d.threshold} items" 
    end
  end

  def discount
    Discount.find(@params[:id])
  end
end