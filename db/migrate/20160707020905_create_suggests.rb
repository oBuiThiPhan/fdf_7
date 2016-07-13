class CreateSuggests < ActiveRecord::Migration
  def change
    create_table :suggests do |t|
      t.integer :user_id
      t.text :content
      t.string :picture
      t.integer :category_id
      t.boolean :status, default: false

      t.timestamps null: false
    end
  end
end
