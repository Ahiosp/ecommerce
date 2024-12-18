class RenamePrixToPriceCentsInProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :products, :prix, :price_cents
  end
end
