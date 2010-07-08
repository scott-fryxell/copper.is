class AddActivationDateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :activation_date, :datetime
  end

  def self.down
    remove_column :users, :activation_date
  end
end
