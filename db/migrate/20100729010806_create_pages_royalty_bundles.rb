class CreatePagesRoyaltyBundles < ActiveRecord::Migration
  def self.up
    create_table :pages_royalty_bundles, :id => false do |t|
      t.integer :page_id
      t.integer :royalty_bundle_id
    end
  end

  def self.down
    drop_table :pages_royalty_bundles
  end
end
