class CleanUpIndexes < ActiveRecord::Migration
  def change
    add_index :authors, [:provider, :uid]
    add_index :authors, [:provider, :username]
  end
end
