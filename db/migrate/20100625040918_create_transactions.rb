class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.references :account,         :null => false
      t.integer    :amount_in_cents, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
