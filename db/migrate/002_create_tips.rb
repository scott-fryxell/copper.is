class CreateTips < ActiveRecord::Migration
  def self.up
    create_table :tips do |t|
      t.references :tip_order, :null => false
      t.references :page, :null => false
      t.integer :amount_in_cents, :null => false
      t.string  :state 
      t.timestamps
    end
  end

  def self.down
    drop_table :tips
  end
end
