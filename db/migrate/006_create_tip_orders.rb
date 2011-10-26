class CreateTipOrders < ActiveRecord::Migration
  def self.up
    create_table   :tip_orders do |t|
      t.boolean    :is_active,      :default => true
      t.references :fan
      t.references :billing_period, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :tip_orders
  end
end
