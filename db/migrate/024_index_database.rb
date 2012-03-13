class IndexDatabase < ActiveRecord::Migration
  def change
    add_index :pages_royalty_orders, [:page_id, :royalty_order_id]
    add_index :identities, [:user_id]
    add_index :locators, [:site_id, :page_id]
    add_index :tip_orders, [:fan_id]
    add_index :tip_royalties, [:royalty_order_id, :tip_id]
    add_index :tips, [:tip_order_id, :locator_id]
  end
end
