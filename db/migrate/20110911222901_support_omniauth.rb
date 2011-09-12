class SupportOmniauth < ActiveRecord::Migration
  def self.up
    add_column :users, :provider, :string
    add_column :users, :uid, :string
  end

  def self.down
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string   
  end
end