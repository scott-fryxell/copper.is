class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :fqdn, :null => false

      t.timestamps
    end
    
    add_index :sites, :fqdn, :unique => true
  end

  def self.down
    drop_table :sites
  end
end
