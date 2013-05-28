class PageDescription < ActiveRecord::Migration
  def change
    add_column :pages, :description, :text
  end
end
