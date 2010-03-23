class RemoveMonthAndYearFromAccount < ActiveRecord::Migration
  def self.up
     remove_column :accounts, :month
     remove_column :accounts, :year
  end

  def self.down
    add_column :accounts, :month, :integer
    add_column :accounts, :year, :integer
  end
end
