class CreateLocators < ActiveRecord::Migration
  def self.up
    create_table :locators do |t|
      t.string :scheme
      t.string :userinfo
      t.integer :port
      t.string :registry      
      t.string :path
      t.string :opaque
      t.string :query
      t.string :fragment
      t.string :url
      t.integer :site_id
      t.integer :tips_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :locators
  end
end
