class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.float :total_price
      t.integer :status
      t.text :shipping_address

      t.timestamps null: false
    end
  end
end
