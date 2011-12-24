class RemoveUserProviderInfo < ActiveRecord::Migration
  def up
    remove_column :users, :provider_info
  end

  def down
    add_column :users, :provider_info, :string
  end
end