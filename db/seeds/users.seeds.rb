after :roles, :authors do
  puts('creating users')
  scott = User.find_or_create_by!(email:'scott@copper.is', name:'eScott', accept_terms:true)
  scott.roles << Role.find_by(name:'fan')
  scott.roles << Role.find_by(name:'admin')
  # TODO: Email should be the unique within the system
end
