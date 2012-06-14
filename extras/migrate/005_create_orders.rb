class CreateOrders < ActiveRecord::Migration
  def change
    create_table   :orders do |t|
      t.references :fan
      t.string     :order_state
      t.string     :charge_token
      t.timestamps
    end
  end
end
