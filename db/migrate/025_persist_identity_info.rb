class PersistIdentityInfo < ActiveRecord::Migration
  def change
    add_column :identities, :name, :string
    add_column :identities, :email, :string
    add_column :identities, :image, :string
    add_column :identities, :location, :string
    add_column :identities, :phone, :string
    add_column :identities, :urls, :string
    add_column :identities, :token, :string
  end
end
