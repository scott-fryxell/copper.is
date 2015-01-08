class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string  :title
      t.text    :description
      t.text    :thumbnail_url
      t.text    :url,          :null => false
      t.string  :author_state
      t.boolean :nsfw, default:false
      t.references :author
      t.timestamps
    end
    add_index :pages, :url
  end
end
