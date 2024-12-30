class ChangePrixToIntegerInProducts < ActiveRecord::Migration[8.0]
  def change
    change_column :products, :prix, :integer
  end
end
