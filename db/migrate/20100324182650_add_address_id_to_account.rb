class AddAddressIdToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :address_id, :integer
  end

  def self.down
    remove_column :accounts, :address_id
  end
end
