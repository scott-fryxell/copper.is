class CreateConfiguration < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string  :property
      t.string  :value
      t.timestamps 
    end
  end

  def self.down
    drop table :configurations
  end
end
