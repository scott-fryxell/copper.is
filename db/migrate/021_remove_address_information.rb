class RemoveAddressInformation < ActiveRecord::Migration
  def change
    remove_column :users, :payable_to
    remove_column :users, :line1
    remove_column :users, :line2
    remove_column :users, :city
    remove_column :users, :postal_code
    remove_column :users, :subregion_code
    remove_column :users, :country_code
  end

end
