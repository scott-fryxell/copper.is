after :roles do
  User.find_or_create_by_name!('eScott', email:'scott@copper.is', accept_terms:true)
end

