class OrdersController < ApplicationController
  before_action :authenticate_user!
  def create
    @cart = current_cart
    @order = current_user.orders.create!(
      cart: @cart,
      state: "pending",
      total_amount_cents: @cart.total_price_cents,
    )
    redirect_to new_payment_path(order_id: @order.id)
  end

  def show
    @order = Order.find(params[:id])
  end
end
