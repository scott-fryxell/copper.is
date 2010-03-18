class AddColumnsToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :card_type, :string
    add_column :accounts, :verification_value, :integer
    add_column :accounts, :month, :integer
    add_column :accounts, :year, :integer
    add_column :accounts, :first_name, :string
    add_column :accounts, :last_name, :string
  end

  def self.down
    remove_column :accounts, :card_type
    remove_column :accounts, :verification_value
    remove_column :accounts, :month
    remove_column :accounts, :year
    remove_column :accounts, :first_name
    remove_column :accounts, :last_name
  end
end
