class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :provider, :null => false
      t.string :uid
      t.string :username
      t.string :token
      t.string :secret
      t.string :type, :null => false
      t.string :identity_state
      t.text   :image
      t.hstore :preferences
      t.references :user
      t.timestamps
    end
    add_index :authors, [:provider, :uid]
    add_index :authors, [:provider, :username]
  end
end
