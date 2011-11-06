class AddProviderInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :provider_info, :text
  end
end
