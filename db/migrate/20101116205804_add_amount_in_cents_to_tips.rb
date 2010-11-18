class AddAmountInCentsToTips < ActiveRecord::Migration
  def self.up
    add_column :tips, :amount_in_cents, :integer
  end

  def self.down
    remove_column :tips, :amount_in_cents
  end
end
