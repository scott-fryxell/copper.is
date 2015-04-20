class ChangePageUrlFromStringToText < ActiveRecord::Migration
  def change
    change_column :pages, :url, :text
  end
end
