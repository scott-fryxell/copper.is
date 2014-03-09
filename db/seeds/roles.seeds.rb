puts "creating roles"
roles = Role.find_or_create_by_name!([
  { name:'Fan' },
  { name:'Curator' },
  { name:'Author' },
  { name:'Guest' },
  { name:'Admin' },
  { name:'God' }
])
