class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  helper_method :current_cart

  def current_cart
    if current_user
      @current_cart ||= Cart.find_or_create_by(user: current_cart)
    else
      nil
    end
  end
end
