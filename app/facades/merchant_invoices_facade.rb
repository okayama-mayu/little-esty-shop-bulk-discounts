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

  def discounted_rev
    @invoice.total_revenue - total_discounts
  end

  def discount_stats
    stats = Hash.new 
    @invoice.all_discounts.map do |discount| 
      stats[discount.discount_id.to_s] = "#{discount.max_disc}% off Discount with Threshold of #{discount.count_threshold} Applied"
    end
    stats 
  end
end