class CreateFees < ActiveRecord::Migration
  def self.up
    create_table :fees do |t|
      t.references :transaction, :null => false
      t.integer    :amount_in_cents

      t.timestamps
    end
  end

  def self.down
    drop_table :fees
  end
end
