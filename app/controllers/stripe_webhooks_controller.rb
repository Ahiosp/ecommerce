class StripeWebhooksController < ApplicationController
  # Désactivation de la protection CSRF pour ce webhook
  protect_from_forgery except: :create

  def create
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    event = nil

    # Tentative de construction de l'événement Stripe à partir du payload et de la signature
    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV["STRIPE_WEBHOOK_SECRET_KEY"]
      )
    rescue JSON::ParserError => e
      # Impossible de lire le payload, on retourne une erreur 400
      Rails.logger.error("Stripe Webhook - Erreur de parsing : #{e.message}")
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError => e
      # La signature ne correspond pas, on retourne une erreur 400
      Rails.logger.error("Stripe Webhook - Erreur de signature : #{e.message}")
      head :bad_request
      return
    end

    # Traitement de l'événement selon son type
    case event["type"]
    when "checkout.session.completed"
      session = event["data"]["object"]
      handle_checkout_session(session)
    else
      Rails.logger.info("Stripe Webhook - Événement ignoré : #{event['type']}")
    end

    # Retourner un statut 200 pour indiquer que le webhook a bien été traité
    head :ok
  end

  private

  # Méthode pour traiter l'événement checkout.session.completed
  def handle_checkout_session(session)
    # On récupère la commande à partir de l'ID de la session Stripe
    order = Order.find_by(checkout_session_id: session["id"])

    if order
      # Si la commande existe, on la met à jour avec l'état "paid"
      order.update(state: "paid")
      Rails.logger.info("Stripe Webhook - Commande #{order.id} marquée comme payée.")
    else
      Rails.logger.error("Stripe Webhook - Commande non trouvée pour la session ID #{session['id']}")
    end
  end
end
