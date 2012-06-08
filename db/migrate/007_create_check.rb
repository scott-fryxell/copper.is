class CreateCheck < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.references :user
      t.string  :check_state
      t.integer :count, :default => 0
      t.timestamps
    end
    add_index :checks, :user_id
  end
end
