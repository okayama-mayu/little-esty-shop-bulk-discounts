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

  def holidays 
    service.holidays.map do |data| 
      Holiday.new(data)
    end
  end

  def service 
    HolidayService.new 
  end

  def next_3_holidays
    arr = []
    test = holidays.each do |holiday| 
      if holiday.global == true 
        arr << "#{holiday.name}: #{holiday.date}"
        break if arr.compact.count == 3
      else 
        next
      end 
    end 
    arr 
  end

  def discount_deletable? 
    pending_invoice = @merchant.pending_invoices
    pending_invoice.each do |invoice| 
      invoice.all_discounts.each do |inv_disc| 
        return false if inv_disc.discount_id == discount.id 
      end
    end
    return true 
  end
end