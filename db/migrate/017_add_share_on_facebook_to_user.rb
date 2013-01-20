class AddShareOnFacebookToUser < ActiveRecord::Migration
  def change
    add_column :users, :share_on_facebook, :boolean
  end
end
