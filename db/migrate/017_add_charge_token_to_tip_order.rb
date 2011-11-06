class AddChargeTokenToTipOrder < ActiveRecord::Migration
  def change
    add_column :tip_orders, :charge_token, :string
  end
end
