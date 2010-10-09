class TightenUpAccounts < ActiveRecord::Migration
  def self.up
    # number [NON-NULL]
    change_column(:accounts, :number, :string, {:null => false, :limit => 16})

    # card_type          => card_type_id [NON-NULL] (normalization)
    remove_column(:accounts, :card_type)
    add_column(:accounts, :card_type_id, :integer)
    # Have to do this as a second step because SQLite3 complains if you try to
    # add a non-null column with a null "default" value (i.e. no default value
    # set). No idea why it's cool with doing it as two steps.
    change_column(:accounts, :card_type_id, :integer, {:null => false})

    # verification_value => verification_code (clarification)
    rename_column(:accounts, :verification_value, :verification_code)

    # first_name         => DROPPED (normalization)
    remove_column(:accounts, :first_name)

    # last_name          => billing_name [NON-NULL] (normalization)
    rename_column(:accounts, :last_name, :billing_name)
    change_column(:accounts, :billing_name, :string, {:null => false, :limit => 4096})

    # card_expires_on    => expires_on [NON-NULL] (clarification)
    rename_column(:accounts, :card_expires_on, :expires_on)
    change_column(:accounts, :expires_on, :date, {:null => false})

    # address_id         => billing_address_id [NON-NULL] (clarification)
    rename_column(:accounts, :address_id, :billing_address_id)
    change_column(:accounts, :billing_address_id, :integer, {:null => false})

    # user_id [NON-NULL]
    change_column(:accounts, :user_id, :integer, {:null => false})
  end

  def self.down
    # user_id [NON-NULL]
    change_column(:accounts, :user_id, :integer, {:null => true})

    # address_id         => billing_address_id [NON-NULL] (clarification)
    change_column(:accounts, :billing_address_id, :integer, {:null => true})
    rename_column(:accounts, :billing_address_id, :address_id)

    # card_expires_on    => expires_on [NON-NULL] (clarification)
    change_column(:accounts, :expires_on, :date, {:null => true})
    rename_column(:accounts, :expires_on, :card_expires_on)

    # last_name          => billing_name [NON-NULL] (normalization)
    change_column(:accounts, :billing_name, :string, {:null => true, :limit => 255})
    rename_column(:accounts, :billing_name, :last_name)

    # first_name         => DROPPED (normalization)
    add_column(:accounts, :first_name, :string)

    # verification_value => verification_code (clarification)
    rename_column(:accounts, :verification_code, :verification_value)

    # card_type          => card_type_id [NON-NULL] (normalization)
    remove_column(:accounts, :card_type_id)
    add_column(:accounts, :card_type, :string)

    # number [NON-NULL]
    change_column(:accounts, :number, :integer, {:null => true})
  end
end
