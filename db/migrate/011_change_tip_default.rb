class ChangeTipDefault < ActiveRecord::Migration
  def up
    change_column_default(:users, :tip_preference_in_cents, 50)
  end

  def down
    change_column_default(:users, :tip_preference_in_cents, 25)
  end
end
