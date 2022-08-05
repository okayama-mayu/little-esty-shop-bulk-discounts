class MerchantDiscountsController < ApplicationController 
  def index 
    @facade = MerchantDiscountsFacade.new(params)
  end

  def show 

  end
  
  def new 
    @facade = MerchantDiscountsFacade.new(params)
  end
end