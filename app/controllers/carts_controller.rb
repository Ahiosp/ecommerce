class CartsController < ApplicationController
before_action :set_cart, only: [ :index, :show ]
  def index
    load_cart_data
  end

  def show
    load_cart_data
  end

  private

  def load_cart_data
    @cart_items = @cart.cart_items
    @order = @cart.order
  end

  def set_cart
    @cart = current_cart
  end
end
