class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :user_name
      t.string :token
      t.string :secret
      t.string :type
      t.string :identity_state
      t.references :author
      t.timestamps
    end
    add_index :identities, [:type, :uid]
  end
end
