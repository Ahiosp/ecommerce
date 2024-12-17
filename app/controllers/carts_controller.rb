class CartsController < ApplicationController
before_action :set_cart, only: [ :index, :show ]
  def index
    @cart_items  = @cart.cart_items
  end

  def show
    @cart_items = @cart.cart_items
  end

  private

  def set_cart
    @cart = current_cart
  end
end
