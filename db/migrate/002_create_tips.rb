class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.references :order, :null => false
      t.references :check
      t.references :page
      t.integer :amount_in_cents, :null => false
      t.string :title
      t.string :paid_state 
      t.timestamps
    end
    add_index :tips, :order_id
  end
end
