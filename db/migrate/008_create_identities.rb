class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider, :null => false
      t.string :uid
      t.string :username
      t.string :token
      t.string :secret
      t.string :type, :null => false
      t.string :identity_state
      t.datetime :message
      t.references :user
      t.timestamps
    end
    add_index :identities, [:provider, :uid]
    add_index :identities, [:provider, :username]
  end
end
