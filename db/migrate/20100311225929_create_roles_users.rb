class CreateRolesUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false do |t| 
      t.integer :user_id 
      t.integer :role_id
    end
    # Indexes are important for performance if join tables grow big
    add_index :roles_users, [:user_id, :role_id], :unique => true
  end

  def self.down
  end
end
