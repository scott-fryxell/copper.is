class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :description, :null => false

      t.timestamps
    end

    add_column :locators, :page_id, :integer
  end

  def self.down
    remove_column :locators, :page_id
    drop_table :pages
  end
end
