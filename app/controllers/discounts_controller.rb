class DiscountsController < ApplicationController
  include DiscountCalculations

  def calculate
    product = Product.find_by(id: params[:product_id])
    user = User.find_by(token: params[:user_token])

    return render json: { error: "Product or user not found" }, status: :not_found unless product && user
    
    discount_info = calculate_discount(product, user)
    render json: discount_info
  end

  private

  def discount_params
    params.permit(:product_id, :user_token)
  end
end
