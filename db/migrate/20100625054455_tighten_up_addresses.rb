class TightenUpAddresses < ActiveRecord::Migration
  def self.up
    rename_column(:addresses, :street1, :line_1)
    rename_column(:addresses, :street2, :line_2)
    rename_column(:addresses, :zip,     :postal_code)

    add_column(:addresses, :territory, :varchar)
    
    change_column(:addresses, :line_1,      :varchar, {:null => false})
    change_column(:addresses, :city,        :varchar, {:null => false})
    # The Rails PostgreSQL adapter is too dumb to understand a limit declaration on a char column
    execute 'ALTER TABLE addresses ALTER COLUMN state TYPE CHAR(2)'
    execute 'ALTER TABLE addresses ALTER COLUMN state SET NOT NULL'
    change_column(:addresses, :postal_code, :varchar, {:null => false})
    change_column(:addresses, :country,     :varchar, {:null => false, :default => 'USA'})
  end

  def self.down
    change_column(:addresses, :country,     :varchar, {:null => true, :default => nil})
    change_column(:addresses, :postal_code, :varchar, {:null => true})
    change_column(:addresses, :state,       :varchar, {:limit => 255, :null => true})
    change_column(:addresses, :city,        :varchar, {:null => true})
    change_column(:addresses, :line_1,      :varchar, {:null => true})

    remove_column(:addresses, :territory)

    rename_column(:addresses, :postal_code, :zip)
    rename_column(:addresses, :line_2,      :street2)
    rename_column(:addresses, :line_1,      :street1)
  end
end
