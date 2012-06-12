class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :type
      t.string :name
      t.timestamps
    end
  end
end
