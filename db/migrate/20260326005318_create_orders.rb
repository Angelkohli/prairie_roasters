class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.datetime :order_date
      t.decimal :total
      t.string :status
      t.string :stripe_payment_id
      t.timestamps
    end
  end
end