class CleanUpUser < ActiveRecord::Migration
  def self.up    
    remove_column :users, :username, :string
    remove_column :users, :persistence_token, :string

    add_column :users, :name, :string
  end

  def self.down
    add_column :users, :username, :string
    remove_column :users, :name, :string
    add_column :users, :persistence_token, :string
  end
end
