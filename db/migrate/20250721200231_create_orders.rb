class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :user_id, null: false
      t.string :pickup_address, null: false
      t.string :delivery_address, null: false
      t.text :items_description, null: false
      t.datetime :requested_at, null: false
      t.decimal :estimated_value, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :requested_at
  end
end
