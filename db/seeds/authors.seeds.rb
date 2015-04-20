
after :users do
  puts "creating authors"
  scott = User.find_by_email('scott@copper.is')
  author = Author.find_or_create_by_provider_and_uid("facebook", '580281278')
  author.user = scott
  author.join!
end
