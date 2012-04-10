class CreateRoyaltyCheck < ActiveRecord::Migration
  def self.up
    create_table :royalty_checks do |t|
      t.references :user,    :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :royalty_checks
  end
end
