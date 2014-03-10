puts "creating roles"
Role.find_or_create_by_name!('fan')
Role.find_or_create_by_name!('author')
Role.find_or_create_by_name!('guest')
Role.find_or_create_by_name!('admin')
Role.find_or_create_by_name!('god')
