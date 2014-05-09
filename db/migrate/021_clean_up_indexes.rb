class CleanUpIndexes < ActiveRecord::Migration
  def change
    remove_index :authors, [:provider, :uid]
    remove_index :authors, [:provider, :username]

    add_index :authors, [:provider, :uid]
    add_index :authors, [:provider, :username]
  end
end
