class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string  :title
      t.string  :url,          :null => false
      t.string  :author_state
      t.references :identity
      t.timestamps
    end
    add_index :pages, :url
  end

  def self.down
    drop_table :pages
  end
end
