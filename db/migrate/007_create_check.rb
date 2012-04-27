class CreateCheck < ActiveRecord::Migration
  def self.up
    create_table :checks do |t|
      t.references :user
      t.string  :check_state
      t.integer :count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :checks
  end
end
