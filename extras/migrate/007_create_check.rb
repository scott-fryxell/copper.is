class CreateCheck < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :author
      t.string  :check_state
      t.timestamps
    end
    add_index :checks, :author_id
  end
end
