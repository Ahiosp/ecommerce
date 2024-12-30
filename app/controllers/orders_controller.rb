class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def new
    @order = Order.new
  end
  def create
    @cart = current_cart
    @order = current_user.orders.create!(
      cart: @cart,
      state: "pending",
      total_amount_cents: @cart.total_price_cents,
    )
    if @order.save
      redirect_to new_payment_path(order_id: @order.id), notice: "Commande créée avec succès."
    else
      render :new, alert: "Erreur lors de la création de la commande."
    end
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def set_cart
    @cart = current_cart
  end
end
