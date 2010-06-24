class CreateBillingPeriods < ActiveRecord::Migration
  def self.up
    create_table :billing_periods do |t|
      t.timestamps
    end
  end

  def self.down
    drop_table :billing_periods
  end
end
