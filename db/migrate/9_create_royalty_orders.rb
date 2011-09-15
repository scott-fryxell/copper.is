class CreateRoyaltyOrders < ActiveRecord::Migration
  def self.up
    create_table :royalty_orders do |t|
      t.integer    :cycle_started_year,    :null => false
      t.integer    :cycle_started_quarter, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :royalty_orders
  end
end
