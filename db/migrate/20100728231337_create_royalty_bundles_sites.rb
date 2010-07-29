class CreateRoyaltyBundlesSites < ActiveRecord::Migration
  def self.up
    create_table :royalty_bundles_sites, :id => false do |t|
      t.integer :royalty_bundle_id
      t.integer :site_id
    end
  end

  def self.down
    drop_table :royalty_bundles_sites
  end
end
