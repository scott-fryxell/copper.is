class AddTipRateIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tip_rate_id, :integer
  end

  def self.down
    remove_column :users, :tip_rate_id
  end
end
