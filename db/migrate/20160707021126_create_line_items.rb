class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :each_quantity

      t.timestamps null: false
    end
  end
end
