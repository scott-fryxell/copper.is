class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :scheme
      t.string :userinfo
      t.string :host
      t.integer :port
      t.string :registry      
      t.string :path
      t.string :opaque
      t.string :query
      t.string :fragment
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end