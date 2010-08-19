class AddOrderIdToTransactions < ActiveRecord::Migration
  def self.up
    add_column :transactions, :order_id, :integer
  end

  def self.down
    remove_column :transactions, :order_id
  end
end
