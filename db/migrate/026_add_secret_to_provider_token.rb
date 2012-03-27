class AddSecretToProviderToken < ActiveRecord::Migration
  def change
    add_column :identities, :secret, :string
  end
end
