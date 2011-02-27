class AddUrlToLocators < ActiveRecord::Migration
  def self.up
    add_column :locators, :url, :string
  end

  def self.down
    remove_column :locators, :url
  end
end
