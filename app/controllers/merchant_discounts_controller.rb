class MerchantDiscountsController < ApplicationController 
  def index 
    @facade = MerchantDiscountsFacade.new(params)
  end

  def show 

  end
  
  def new 
    @facade = MerchantDiscountsFacade.new(params)
  end

  def create 
    facade = MerchantDiscountsFacade.new(params)
    discount = facade.merchant.discounts.new(merchant_discount_params)

    redirect_decider(discount, params) 
  end

  private 
  def merchant_discount_params 
    params.permit(:discount, :threshold)
  end

  def redirect_decider(discount, params)
    if discount.save 
      redirect_to merchant_discounts_path(params[:merchant_id]), notice: "Merchant Discount was successfully added."
    else 
      redirect_to new_merchant_discount_path(params[:merchant_id]), alert: "Error: Please fill in all fields with numbers."
    end
  end
end