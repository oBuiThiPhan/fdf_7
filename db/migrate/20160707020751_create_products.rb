class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :image
      t.float :price
      t.integer :category_id
      t.float :rate_score, default: 0.0
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
