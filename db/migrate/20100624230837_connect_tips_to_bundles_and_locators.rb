class ConnectTipsToBundlesAndLocators < ActiveRecord::Migration
  def self.up
    create_table :tips, :force => true do |t|
      t.references :tip_bundle, :null => false
      t.references :locator, :null => false
      t.integer    :multiplier, :default => 1

      t.timestamps
    end
  end

  def self.down
    create_table :tips, :force => true do |t|
      t.text     :url
      t.decimal  :amount
      t.integer  :user_id

      t.timestamps
    end
  end
end
