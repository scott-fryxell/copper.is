class CreateTips < ActiveRecord::Migration
  def self.up
    create_table :tips do |t|
      t.references :tip_order, :null => false
      t.references :royalty_check
      t.references :page, :null => false
      t.integer :amount_in_cents, :null => false
      t.string  :paid_state 
      t.timestamps
    end
  end

  def self.down
    drop_table :tips
  end
end
