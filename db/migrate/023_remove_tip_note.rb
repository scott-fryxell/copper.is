class RemoveTipNote < ActiveRecord::Migration
  def up
    remove_column :tips, :note
  end

  def down
    add_column :tips, :note, :string
  end
end
