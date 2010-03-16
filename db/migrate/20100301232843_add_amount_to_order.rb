class AddAmountToOrder < ActiveRecord::Migration
  def self.up
    add_column :orders, :amount, :decimal
  end

  def self.down
    remove_column :orders, :amount
  end
end
