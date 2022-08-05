class MerchantDiscountsController < ApplicationController 
  def index 
    @facade = MerchantDiscountsFacade.new(params)
  end
end