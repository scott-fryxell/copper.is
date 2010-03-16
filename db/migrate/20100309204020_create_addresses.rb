class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :zip
      t.string :country

      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
