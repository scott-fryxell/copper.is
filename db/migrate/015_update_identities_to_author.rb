class UpdateIdentitiesToAuthor < ActiveRecord::Migration
  def up
    execute <<-SQL
      UPDATE authors
      SET type = 'Authors::Facebook'
      WHERE type = 'Identities::Facebook';

      UPDATE authors
      SET type = 'Authors::Twitter'
      WHERE type = 'Identities::Twitter';

      UPDATE authors
      SET type = 'Authors::Google'
      WHERE type = 'Identities::Google';

      UPDATE authors
      SET type = 'Authors::Soundcloud'
      WHERE type = 'Identities::Soundcloud';
    SQL
  end

  def down
    execute <<-SQL
      UPDATE authors
      SET type = 'Identities::Facebook'
      WHERE type = 'Authors::Facebook';

      UPDATE authors
      SET type = 'Identities::Twitter'
      WHERE type = 'Authors::Twitter';

      UPDATE authors
      SET type = 'Identities::Google'
      WHERE type = 'Authors::Google';

      UPDATE authors
      SET type = 'Identities::Soundcloud'
      WHERE type = 'Authors::Soundcloud';
    SQL
    
  end
end
