class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.references :author
      t.string :address
      t.string :type
      t.timestamps
    end
    add_index :channels, :author_id
  end
end
