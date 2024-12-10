class Product < ApplicationRecord
  has_many :cart_items
  has_many :carts, through: :cart_items
  has_one_attached :image
end
