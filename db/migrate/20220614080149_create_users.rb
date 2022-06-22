class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :web_url
      t.string :title
      t.string :description
      t.boolean :is_active
      t.boolean :is_deleted
      t.integer :friends_count

      t.timestamps
    end
  end
end
