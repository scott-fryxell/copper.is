class AddExpiresOn < ActiveRecord::Migration
  def self.up
     add_column :accounts, :card_expires_on, :date
  end

  def self.down
     remove_column :accounts, :card_expires_on
  end
end
