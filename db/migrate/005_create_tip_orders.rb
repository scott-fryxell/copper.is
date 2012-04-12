class CreateTipOrders < ActiveRecord::Migration
  def self.up
    create_table   :tip_orders do |t|
      t.references :user,    :null => false
      t.string     :state
      t.string     :charge_token
      t.timestamps
    end
  end

  def self.down
    drop_table :tip_orders
  end
end
