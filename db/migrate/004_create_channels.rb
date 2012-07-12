class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.references :page
      t.string :user
      t.string :site
      t.string :type
      t.timestamps
    end
    add_index :channels, :page_id
    add_index :channels, :site
  end
end
