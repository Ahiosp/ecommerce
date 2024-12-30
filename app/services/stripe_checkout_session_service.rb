class StripeCheckoutSessionService
  def call(event)
    session = event.data.object
    order = Order.find_by(checkout_session_id: session.id)
    if order
      order.update(state: "paid")
    end
  end
end
