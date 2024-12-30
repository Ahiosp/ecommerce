class ChangeProductToCartInOrders < ActiveRecord::Migration[8.0]
  def change
    remove_reference :orders, :product, foreign_key: true
    add_reference :orders, :cart, foreign_key: true
  end
end
