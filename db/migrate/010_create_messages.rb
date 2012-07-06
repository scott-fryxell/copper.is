class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject
      t.datetime :sent
      t.string :slug
      t.references :channel
      t.string :redirect_to
      t.datetime :checked
      t.timestamps
    end
  end
end
