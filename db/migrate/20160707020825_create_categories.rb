class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.integer :level
      t.integer :left_index
      t.integer :right_index

      t.timestamps null: false
    end
  end
end
