class AddPageTumbnailUrl < ActiveRecord::Migration
def up
    add_column :pages, :thumbnail_url, :text
  end

  def down
    remove_column :pages, :thumbnail_url
  end
end
