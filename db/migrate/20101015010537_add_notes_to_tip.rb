class AddNotesToTip < ActiveRecord::Migration
  def self.up
    add_column :tips, :note, :string
  end

  def self.down
    remove_column :tips, :note
  end
end
