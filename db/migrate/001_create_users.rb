class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.integer:tip_preference_in_cents,  :null => false, :default => 50
      t.string :email
      t.string :stripe_customer_id
      t.boolean :accept_terms,            :default => false
      t.boolean :automatic_rebill,        :default => false
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
  
  def self.down
    drop_table :users
  end
end
