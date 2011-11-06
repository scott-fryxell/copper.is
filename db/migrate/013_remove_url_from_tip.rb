class RemoveUrlFromTip < ActiveRecord::Migration
  def up
    remove_column :tips, :url
  end

  def down
    add_column :tips, :url
  end
end
