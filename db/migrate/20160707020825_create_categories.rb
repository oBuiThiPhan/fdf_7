class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.integer :level
      t.integer :left
      t.integer :right

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :categories
  end
end
