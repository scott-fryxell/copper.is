class RenameAmountToAmountInCentsForOrders < ActiveRecord::Migration
  def self.up
    rename_column(:orders, :amount, :amount_in_cents)
  end

  def self.down
    rename_column(:orders, :amount_in_cents, :amount)
  end
end
