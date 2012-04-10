class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name
      t.integer   :tip_preference_in_cents,  :null => false, :default => 50
      t.string   :email
      t.string   :stripe_customer_id
      t.boolean  :accept_terms,            :default => false
      t.boolean  :automatic_rebill,        :default => false
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
end
