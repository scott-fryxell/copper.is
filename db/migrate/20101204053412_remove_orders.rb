class RemoveOrders < ActiveRecord::Migration
  def self.up
    drop_table :orders
  end

  def self.down
     create_table :orders do |t|
        t.string :ip_address
        t.integer :amount_in_cents
        t.integer :account_id
        t.timestamps
      end
  end
end