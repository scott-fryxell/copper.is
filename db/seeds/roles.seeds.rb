puts "creating roles"
Role.find_or_create_by_name!('Fan')
Role.find_or_create_by_name!('Curator')
Role.find_or_create_by_name!('Author')
Role.find_or_create_by_name!('Guest')
Role.find_or_create_by_name!('Admin')
Role.find_or_create_by_name!('God')
