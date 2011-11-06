class RemoveUserFromTip < ActiveRecord::Migration
  def up
    remove_column :tips, :user_id
  end

  def down
    add_column :tips, :user_id
  end
end
