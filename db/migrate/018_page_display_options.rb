class PageDisplayOptions < ActiveRecord::Migration
  def change
    add_column :pages, :onboarding, :boolean, :default => false
    add_column :pages, :welcome, :boolean, :default => false
    add_column :pages, :trending, :boolean, :default => false
    add_column :pages, :nsfw, :boolean, :default => false
  end
end