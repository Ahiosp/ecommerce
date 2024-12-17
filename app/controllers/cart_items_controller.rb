class CartItemsController < ApplicationController
  before_action :set_cart, only: [ :create, :destroy ]
  def create
    @product = Product.find(params[:product_id])

    if @product.disponibilité != "en stock"
      redirect_to product_path(@product), alert: "Le produit n'est plus disponible."
      return
    end

    @cart_item = @cart.cart_items.find_or_initialize_by(product: @product)

    if @cart_item.new_record?
      if @cart_item.save
      # session[:cart_id] = @cart.id
        notice = "Produit ajouté au panier."
      else
        notice = "Une erreur est survenue lors de l'ajout au panier."
      end
    else
    notice = "Le produit est déjà dans votre panier."
    end

    redirect_to carts_path, notice: notice
  end

  def destroy
    @cart_item = @cart.cart_items.find_by(id: params[:id])
    if @cart_item
      @cart_item.destroy
      redirect_to carts_path(@cart), notice: "Produit retiré du panier."
    else
      redirect_to carts_path(@cart), alert: "Produit introuvable dans le panier."
    end
  end

  private

  def set_cart
    @cart = current_cart
  end
end
