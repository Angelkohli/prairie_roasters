class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :roast_level
      t.string :origin
      t.integer :stock_quantity
      t.timestamps
    end
  end
end