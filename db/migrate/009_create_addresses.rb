class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :postal_code
      t.string :country
      t.string :state
      t.string :territory
      t.string :city
      t.references :user
      t.timestamps
    end
  end
end
