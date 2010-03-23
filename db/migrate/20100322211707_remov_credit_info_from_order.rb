class RemovCreditInfoFromOrder < ActiveRecord::Migration
  def self.up
    remove_column :orders, :first_name
    remove_column :orders, :last_name
    remove_column :orders, :card_type
    remove_column :orders, :card_expires_on
    
  end

  def self.down
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :card_type, :string
    add_column :orders, :card_expires_on, :date        
  end
end