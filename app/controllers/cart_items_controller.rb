class CartItemsController < ApplicationController
  def create
    @product = Product.find(params[product_id])
    @cart = Cart.find(params[cart_id])
    @cart.add_product(@product)
    redirect_to product_path, notice: "Produit ajouté au panier."
  end

  def update
  end

  def destroy
  end
end
