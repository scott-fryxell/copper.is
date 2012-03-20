class PersistIdentityInfo < ActiveRecord::Migration
  def up
    add_column :identities, :name, :string
    add_column :identities, :email, :string
    add_column :identities, :image, :string
    add_column :identities, :location, :string
    add_column :identities, :phone, :string
    add_column :identities, :urls, :string
    add_column :identities, :token, :string
  end

  def down
    remove_column :identities, :name
    remove_column :identities, :email
    remove_column :identities, :image
    remove_column :identities, :location
    remove_column :identities, :phone
    remove_column :identities, :urls
    remove_column :identities, :token
  end
end
