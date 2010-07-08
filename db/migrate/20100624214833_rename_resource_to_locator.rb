class RenameResourceToLocator < ActiveRecord::Migration
  def self.up
    rename_table(:resources, :locators)
  end

  def self.down
    rename_table(:locators, :resources)
  end
end
