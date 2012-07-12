class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.references :order, null:false
      t.references :check
      t.references :page
      t.integer :amount_in_cents, null:false
      t.string :url, null:false
      t.string :title
      t.string :tip_state 
      t.timestamps
    end
    add_index :tips, :order_id
    add_index :tips, :check_id
    add_index :tips, :page_id
  end
end
