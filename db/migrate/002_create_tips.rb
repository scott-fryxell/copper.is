class CreateTips < ActiveRecord::Migration
  def self.up
    create_table :tips do |t|
      t.text :url
      t.integer :user_id
      t.integer :amount_in_cents
      t.string  :note
      t.integer :tip_order_id, :null => false
      t.integer :locator_id, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :tips
  end
end
