class CreateRoyaltyBundles < ActiveRecord::Migration
  def self.up
    create_table :royalty_bundles do |t|
      t.integer    :cycle_started_year,    :null => false
      t.integer    :cycle_started_quarter, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :royalty_bundles
  end
end
