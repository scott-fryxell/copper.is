class RemoveQuartlyPaymentRequirement < ActiveRecord::Migration
  def change
    remove_column :royalty_orders, :cycle_started_year
    remove_column :royalty_orders, :cycle_started_quarter
  end
end
