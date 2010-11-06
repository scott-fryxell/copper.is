class CreateTipRates < ActiveRecord::Migration
  def self.up
    create_table :tip_rates do |t|
      t.integer :amount_in_cents
    end
  end

  def self.down
    drop_table :tip_rates
  end
end
