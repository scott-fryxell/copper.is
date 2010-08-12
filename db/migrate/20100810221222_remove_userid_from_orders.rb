class RemoveUseridFromOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :user_id
  end

  def self.down
    add_column :orders, :user_id, :integer
  end
end
