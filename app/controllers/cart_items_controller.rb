class CartItemsController < ApplicationController
  before_action :set_cart, only: [ :create, :destroy ]
  def create
    @product = Product.find(params[:product_id])

    if @product.disponibilité != "en stock"
      redirect_to product_path(@product), alert: "Le produit n'est plus disponible."
    end

    @cart_item = @cart.cart_items.find_or_initialize_by(product: @product)

    if @cart_item.new_record?
      @cart_item.save
      notice = "Produit ajouté au panier."
    else
      notice = "Le produit est déjà dans votre panier."
    end

    redirect_to carts_path(@cart), notice: notice
  end

  def destroy
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path(@cart), notice: "Produit retiré du panier."
  end

  private

  def set_cart
    @cart = current_cart
  end
end
