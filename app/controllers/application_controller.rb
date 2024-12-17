class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_cart
  before_action :store_user_location!, if: :storable_location?

  def current_cart
    if current_user
      @current_cart ||= current_user.cart || current_user.create_cart
    else
      @current_cart ||= Cart.find_or_create_by(id: session[:cart_id])
    end
    session[:cart_id] = @current_cart.id
    @current_cart
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || super
  end

  private

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  def storable_location?
    request.get? && !request.xhr? && !devise_controller?
  end
end
