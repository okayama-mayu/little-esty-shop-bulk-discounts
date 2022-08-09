class MerchantDiscountsController < ApplicationController 
  def index 
    @facade = MerchantDiscountsFacade.new(params)
  end

  def show 
    @facade = MerchantDiscountsFacade.new(params)
  end
  
  def new 
    @facade = MerchantDiscountsFacade.new(params)
  end

  def create 
    facade = MerchantDiscountsFacade.new(params)
    discount = facade.merchant.discounts.new(merchant_discount_params)

    redirect_decider(discount, params) 
  end

  def destroy 
    discount = Discount.find(params[:id])
    pending_invoice_check(discount, params)
  end

  def pending_invoice_check(discounts, params)
    merchant = Merchant.find(params[:merchant_id])
    if merchant.has_pending 
      flash[:alert] = 'Merchant has one or more Pending Invoices. Discount cannot be deleted when an Invoice is pending.'
      render :index 
    else 
      discount.destroy 

      redirect_to merchant_discounts_path(params[:merchant_id]), notice: 'Discount has been successfully deleted.'
    end 
  end

  def edit 
    @facade = MerchantDiscountsFacade.new(params)
  end

  def update 
    facade = MerchantDiscountsFacade.new(params)
    
    update_router(facade) 
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

  def update_router(facade)
    if facade.discount.update(merchant_discount_params)
      redirect_to merchant_discount_path(facade.merchant, facade.discount), notice: "Discount has been successfully updated."
    else
      redirect_to edit_merchant_discount_path(facade.merchant, facade.discount), alert: "Error: Discount was not updated. Please fill out the form using numbers."
    end 
  end
end