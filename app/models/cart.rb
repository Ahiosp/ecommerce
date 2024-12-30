class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items
  has_one :order, dependent: :destroy

  def total_price_cents
    cart_items.sum { |item | item.product.price_cents }
  end

  def order
    super || Order.find_or_create_by(state: "pending")
  end
end
