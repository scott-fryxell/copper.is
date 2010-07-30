class AddTipsCountToLocators < ActiveRecord::Migration
  def self.up
    add_column :locators, :tips_count, :integer, :default => 0
  end

  def self.down
    remove_column :locators, :tips_count
  end
end
