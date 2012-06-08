class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :title
      t.string  :url,          :null => false
      t.string  :author_state
      t.references :identity
      t.timestamps
    end
    add_index :pages, :url
  end
end
