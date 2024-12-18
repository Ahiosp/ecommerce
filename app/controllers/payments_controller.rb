class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def new
    # On récupère ou crée la commande associée au panier de l'utilisateur.
    @cart = current_user.cart

    # Vérifiez si une commande existe déjà pour ce panier
    @order = Order.find_by(cart_id: @cart.id, state: 'pending')

    # Si la commande n'existe pas, créez une nouvelle commande.
    unless @order
      @order = Order.create(cart: @cart, state: 'pending')
      if @order.persisted?
        Rails.logger.info("Nouvelle commande créée avec ID: #{@order.id}")
      else
        redirect_to carts_path, alert: "Le panier n'a pas été sauvegardé."
        return
      end
    end

    if @order.nil? || @order.id.nil?
      redirect_to carts_path, alert: "Une erreur est survenue lors de la création du panier."
      return
    else
      Rails.logger.info("Commande trouvée avec ID: #{@order.id}")
    end

    # Créez la session de paiement Stripe.
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: @order.cart.cart_items.map { |item|
        {
          price_data: {
            currency: 'eur',
            product_data: {
              name: item.product.nom,
              images: [url_for(item.product.image)],
            },
            unit_amount: item.product.price_cents,  # Prix en centimes
          },
          quantity: 1,  # Chaque produit est acheté en un seul exemplaire
        }
      },
      mode: 'payment',
      success_url: order_url(@order.id),  # URL de succès après paiement
      cancel_url: order_url(@order.id),   # URL d'annulation
    })
    Rails.logger.debug "Session Stripe créée avec ID: #{session.id}"

    @order.update(checkout_session_id: session.id)

    redirect_to session.url

    rescue Stripe::StripeError => e
      Rails.logger.error "Erreur Stripe lors de la création de la session : #{e.message}"
      redirect_to carts_path, alert: "Une erreur est survenue lors de la création de la session de paiement."
  end

  def create
  end
end
