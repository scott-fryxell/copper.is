class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string  :title,    :null => false
      t.string  :url,      :null => false
      t.references :user,  :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end