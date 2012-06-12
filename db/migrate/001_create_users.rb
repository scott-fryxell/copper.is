class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer:tip_preference_in_cents,  :null => false, :default => 25
      t.string :email
      t.string :stripe_id
      t.boolean :accept_terms,            :default => false
      t.string :line1
      t.string :line2
      t.string :postal_code
      t.string :country
      t.string :state
      t.string :territory
      t.string :city
      t.timestamps
    end
    add_index :users, :email
  end
end
