class AddNewEmailTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :new_email_token, :string
  end

  def self.down
    remove_column :users, :new_email_token
  end
end
