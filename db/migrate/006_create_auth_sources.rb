class CreateAuthSources < ActiveRecord::Migration
  def change
    create_table :auth_sources do |t|
      t.string :uid
      t.string :site
      t.string :user
      t.string :name
      t.string :image
      t.string :location
      t.string :urls
      t.string :token
      t.string :secret
      t.string :type
      t.string :auth_source_state
      t.references :author
      t.references :fan
      t.timestamps
    end
    add_index :auth_sources, [:type, :uid]
    add_index :auth_sources, [:type, :user]
    add_index :auth_sources, [:type, :site]
  end
end
