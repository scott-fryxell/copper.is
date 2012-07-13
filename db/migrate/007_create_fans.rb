class CreateFans < ActiveRecord::Migration
  def change
    create_table :fans do |t|
      t.string     :name
      t.integer    :tip_preference_in_cents, :null => false, :default => 25
      t.string     :stripe_id
      t.references :author
      t.timestamps
    end
    add_index :fans, :stripe_id
  end
end
