puts "creating roles"
Role.find_or_create_by! name:'fan'
Role.find_or_create_by! name:'author'
Role.find_or_create_by! name:'guest'
Role.find_or_create_by! name:'admin'
Role.find_or_create_by! name:'god'
