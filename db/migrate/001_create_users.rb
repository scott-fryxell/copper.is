class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension :hstore
    create_table :users do |t|
      t.string  :name
      t.integer :tip_preference_in_cents,  :null => false, :default => 50
      t.hstore  :preferences
      t.string  :email
      t.string  :stripe_id
      t.boolean :accept_terms,             :default => false
      t.boolean :can_give,                 :default => false
      t.boolean :can_receive,              :default => false
      t.timestamps
    end
    add_index :users, :email
  end
end
