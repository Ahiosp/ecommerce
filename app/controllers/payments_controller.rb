class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_user.cart

    # Vérifie si le panier est vide
    if @cart.cart_items.empty?
      redirect_to carts_path, alert: "Votre panier est vide."
      return
    end

    # Trouve ou crée une commande en attente
    @order = Order.find_or_create_by(cart: @cart, state: "pending") do |order|
      order.total_amount_cents = @cart.total_price_cents
    end

    # Mets à jour le montant total de la commande si nécessaire
    @order.update(total_amount_cents: @cart.total_price_cents) unless @order.total_amount_cents == @cart.total_price_cents

    # Crée une session de paiement Stripe
    begin
      session = Stripe::Checkout::Session.create({
        payment_method_types: [ "card" ],
        line_items: @order.cart.cart_items.map { |item|
          {
            price_data: {
              currency: "eur",
              product_data: {
                name: item.product.nom,
                images: [ url_for(item.product.image) ]
              },
              unit_amount: item.product.price_cents  # Prix en centimes
            },
            quantity: 1  # Chaque produit est acheté en un seul exemplaire
          }
        },
        mode: "payment",
        success_url: order_url(@order.id),  # URL de succès après paiement
        cancel_url: carts_url             # URL d'annulation
      })

      # Enregistre l'ID de la session Stripe dans la commande
      @order.update(checkout_session_id: session.id)

      # Redirige vers l'URL de paiement Stripe
      redirect_to session.url, allow_other_host: true

    rescue Stripe::StripeError => e
      Rails.logger.error "Erreur Stripe lors de la création de la session : #{e.message}"
      redirect_to carts_path, alert: "Une erreur est survenue lors de la création de la session de paiement."
    end  # <-- End du begin ... rescue
  end  # <-- End de la méthode new

  def create
  end
end
