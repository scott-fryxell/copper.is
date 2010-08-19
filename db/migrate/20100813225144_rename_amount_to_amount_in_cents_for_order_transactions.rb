class RenameAmountToAmountInCentsForOrderTransactions < ActiveRecord::Migration
  def self.up
    rename_column(:order_transactions, :amount, :amount_in_cents)
  end

  def self.down
    rename_column(:order_transactions, :amount_in_cents, :amount)
  end
end
