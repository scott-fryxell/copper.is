class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string  :title
      t.string  :url,      :null => false
      t.references :identity
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end