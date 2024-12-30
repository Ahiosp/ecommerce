class RemoveTeddySkuFromOrders < ActiveRecord::Migration[8.0]
  def change
    remove_column :orders, :teddy_sku, :string
  end
end
