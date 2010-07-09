class CreateRefills < ActiveRecord::Migration
  def self.up
    create_table :refills do |t|
      t.references :tip_bundle,      :null => false
      t.references :transaction,     :null => false
      t.integer    :amount_in_cents, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :refills
  end
end
