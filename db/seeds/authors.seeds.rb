
after :users do
  puts "creating authors"
  scott = User.find_by(email:'scott@copper.is')
  author = Author.find_or_create_by(provider:"facebook", uid:'580281278')
  author.user = scott
  author.join!
end
