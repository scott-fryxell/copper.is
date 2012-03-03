class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name
      t.string    :provider
      t.string    :uid
      t.integer   :tip_preference_in_cents,  :null => false, :default => 50
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
end
