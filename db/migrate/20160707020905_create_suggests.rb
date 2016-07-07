class CreateSuggests < ActiveRecord::Migration
  def change
    create_table :suggests do |t|
      t.integer :user_id
      t.text :content
      t.integer :category

      t.timestamps null: false
    end
  end
end
