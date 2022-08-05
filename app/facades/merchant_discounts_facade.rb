class MerchantDiscountsFacade 
  attr_reader :merchant, :discounts 

  def initialize(params)
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def discounts_display 
    @discounts.map do |d| 
      "Discount Amount: #{((d.discount)*100).to_i} percent, Threshold: #{d.threshold} items" 
    end
  end
end