class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :tip_preference_in_cents,  :null => false, :default => 100
      t.string :email
      t.string :stripe_id
      t.boolean :accept_terms,            :default => false
      t.timestamps
    end
    add_index :users, :email
  end
end
