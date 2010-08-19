class AddressCountryDefaultToUs < ActiveRecord::Migration
  def self.up
    change_column(:addresses, :country,     :varchar, {:null => false, :default => 'US'})
  end

  def self.down
    change_column(:addresses, :country,     :varchar, {:null => false, :default => 'USA'})
  end
end
