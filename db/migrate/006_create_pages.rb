class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :url,  :null => false
      t.string :author_state
      t.references :author
      t.references :site
      t.timestamps
    end
  end
end
