class MoveHostnamesToSitesTable < ActiveRecord::Migration
  def self.up
    add_column :locators, :site_id, :integer

    Locator.all.each do |url|
      site = Site.find_or_create_by_fqdn(url.host)
      url.site_id = site.id
    end

    remove_column :locators, :host
  end

  def self.down
    add_column :locators, :host, :string

    Locator.all.each do |url|
      url.host = Site.find(url.site_id).fqdn
    end

    remove_column :locators, :site_id
  end
end
