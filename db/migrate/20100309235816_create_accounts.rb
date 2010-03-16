class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :number
      t.timestamps
    end
  end
  
  def self.down
    drop_table :accounts
  end
end
