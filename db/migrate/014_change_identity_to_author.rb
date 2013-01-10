class ChangeIdentityToAuthor < ActiveRecord::Migration
  def change
    rename_table :identities, :authors
    rename_column :pages, :identity_id, :author_id
  end 
end
