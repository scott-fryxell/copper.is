class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.string :provider, :null => false
      t.string :uid, :null => false
      t.string :name
      t.string :email
      t.string :image
      t.string :location
      t.string :phone
      t.string :urls
      t.string :token
      t.string :secret
      t.references :user
      t.timestamps
    end
  end
end
