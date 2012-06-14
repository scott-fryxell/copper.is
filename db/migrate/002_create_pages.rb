class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :url,  :null => false
      t.string :site
      t.string :path
      t.string :page_state
      t.references :author
      t.timestamps
    end
    add_index :pages, :url
    add_index :pages, :site
  end
end
