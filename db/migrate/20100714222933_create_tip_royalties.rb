class CreateTipRoyalties < ActiveRecord::Migration
  def self.up
    create_table :tip_royalties do |t|
      t.references :royalty_bundle,  :null => false
      t.references :tip,             :null => false
      t.integer    :amount_in_cents, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tip_royalties
  end
end
