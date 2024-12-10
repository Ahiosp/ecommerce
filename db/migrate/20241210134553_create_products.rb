class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :nom
      t.text :description
      t.string :disponibilité
      t.decimal :prix
      t.string :image

      t.timestamps
    end
  end
end
