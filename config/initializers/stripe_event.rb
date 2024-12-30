require_dependency 'stripe_checkout_session_service'

StripeEvent.configure do |config|
  config.signing_secret = Rails.configuration.stripe[:signing_secret]
end

StripeEvent.configure do |config|
  config.subscribe 'checkout.session.completed', StripeCheckoutSessionService.new
end
