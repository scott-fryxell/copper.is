after :roles, :authors do
  puts('creating users')
  scott = User.find_or_create_by_email!('scott@copper.is', name:'eScott', accept_terms:true)
  scott.roles << Role.find_by_name('fan')
  scott.roles << Role.find_by_name('admin')
  # TODO: Email should be the unique witin the system
end

