class RenameTipRoyaltiesToRoyalties < ActiveRecord::Migration
  def change
    remove_index :tip_royalties, [:royalty_order_id, :tip_id]
    rename_table :tip_royalties, :royalties
    add_index :royalties, [:royalty_order_id, :tip_id]
  end
end
