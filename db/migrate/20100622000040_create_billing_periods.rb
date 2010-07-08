class CreateBillingPeriods < ActiveRecord::Migration
  def self.up
    create_table :billing_periods do |t|
      # no attributes, just the IDs
    end
  end

  def self.down
    drop_table :billing_periods
  end
end
