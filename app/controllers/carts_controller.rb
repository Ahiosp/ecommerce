class CartsController < ApplicationController
before_action :set_cart, only: [ :index, :add_product]
  def index
    @cart = current_cart
  end

  def add_product
    @product = Product.find(params[:product_id])

    @cart_item = @cart.cart_item.find_or_initialize_by(product: @product)
    if @cart_item.new_record?
      @cart_item.quantity = 1
    else
      @cart_item.quantity += 1
    end

    if @cart_item.save
      redirect_to cart_path(@cart), notice: "Produit ajouté au panier."
    else
      redirect_to products_path, alert: "Impossible d'\ajouter ce produit au panier."
    end
  end

  private

  def set_cart
    @cart = current_cart
  end
end
