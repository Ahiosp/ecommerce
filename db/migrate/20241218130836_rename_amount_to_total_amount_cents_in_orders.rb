class RenameAmountToTotalAmountCentsInOrders < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :amount, :total_amount_cents
  end
end
