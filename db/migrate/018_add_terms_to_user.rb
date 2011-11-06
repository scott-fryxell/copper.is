class AddTermsToUser < ActiveRecord::Migration
  def change
    add_column :users, :accept_terms, :boolean, :default => false
    add_column :users, :automatic_rebill, :boolean, :default => false
  end
end
