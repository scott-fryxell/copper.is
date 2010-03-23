class AddAccountIdToOrders < ActiveRecord::Migration
  def self.up
  	add_column :orders, :account_id, :integer
  end

  def self.down
  	remove_column :orders, :account_id
  end
end
