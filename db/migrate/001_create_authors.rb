class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name
      t.string :line1
      t.string :line2
      t.string :postal_code
      t.string :country
      t.string :state
      t.string :territory
      t.string :city
      t.integer :user_id, null:true
      t.timestamps
    end
  end
end
