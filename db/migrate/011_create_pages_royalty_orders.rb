class CreatePagesRoyaltyOrders < ActiveRecord::Migration
  def self.up
    create_table :pages_royalty_orders, :id => false do |t|
      t.integer :page_id
      t.integer :royalty_order_id
    end
  end

  def self.down
    drop_table :pages_royalty_orders
  end
end
