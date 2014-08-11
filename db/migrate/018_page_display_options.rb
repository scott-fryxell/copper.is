class PageDisplayOptions < ActiveRecord::Migration
  def change
    add_column :pages, :nsfw, :boolean, :default => false
  end
end
