class ChangeDefaultTipTo75Cents < ActiveRecord::Migration
  def up
    change_column_default(:users, :tip_preference_in_cents, 75)
  end

  def down
    change_column_default(:users, :tip_preference_in_cents, 50)
  end

end

