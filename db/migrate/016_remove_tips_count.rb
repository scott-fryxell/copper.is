class RemoveTipsCount < ActiveRecord::Migration
  def up
    remove_column :pages, :tips_count
  end

  def down
    add_column :pages, :tips_count, :integer, :default => 0

    Page.reset_column_information

    Page.all.each do |page|
      Page.update_counters(page.id, :tips_count => page.tips.length)
    end
  end
end
