class CreateRoyaltyCheck < ActiveRecord::Migration
  def self.up
    create_table :royalty_checks do |t|
      t.references :user
      t.string  :check_state
      t.integer :count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :royalty_checks
  end
end
