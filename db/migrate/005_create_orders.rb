class CreateOrders < ActiveRecord::Migration
  def change
    create_table   :orders do |t|
      t.references :user,    :null => false
      t.string     :order_state
      t.string     :charge_token
      t.timestamps
    end
  end
end
