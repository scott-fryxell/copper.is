class AddAuthlogicRpxMigration < ActiveRecord::Migration
  def self.up
    create_table :rpx_identifiers do |t|
      t.string  :identifier, :null => false
      t.string  :provider_name
      t.integer :user_id, :null => false
      t.timestamps
    end
    add_index :rpx_identifiers, :identifier, :unique => true, :null => false
    add_index :rpx_identifiers, :user_id, :unique => false, :null => false

    # remove_column :users, :crypted_password
    #     remove_column :users, :password_salt
    #     remove_column :users, :email
    #     remove_column :users, :name
    #     remove_column :users, :new_email
    #     remove_column :users, :new_email_token
    #     remove_column :users, :facebook_uid
    #     remove_column :users, :facebook_session_id
    # == Customisation may be required here ==
    # You may need to remove database constraints on other fields if they will be unused in the RPX case
    # (e.g. crypted_password and password_salt to make password authentication optional).
    # If you are using auto-registration, you must also remove any database constraints for fields that will be automatically mapped
    # e.g.:

  end

  def self.down
    drop_table :rpx_identifiers

    # == Customisation may be required here ==
    # Restore user model database constraints as appropriate
    # e.g.:
    [:crypted_password, :password_salt].each do |field|
      User.all(:conditions => "#{field} is NULL").each { |user| user.update_attribute(field, "") if user.send(field).nil? }
      change_column :users, field, :string, :default => "", :null => false
    end

  end
end
