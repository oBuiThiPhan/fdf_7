class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :level
      t.integer :left_id
      t.integer :right_id

      t.timestamps null: false
    end
  end
end
