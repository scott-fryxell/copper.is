after :roles, :authors do
  puts('creating users')
  User.find_or_create_by_email!('scott@copper.is', name:'eScott', accept_terms:true)
  # TODO: Email should be the unique witin the system
end

