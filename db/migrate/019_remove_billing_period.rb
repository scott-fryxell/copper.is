class RemoveBillingPeriod < ActiveRecord::Migration
  def up
    remove_column :tip_orders, :billing_period_id
  end

  def down
    add_column :tip_orders, :billing_period_id, :default => 1
  end
end
