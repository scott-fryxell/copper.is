after :tips do
  puts "indexing pages"
  Page.orphaned.each do |page|
    page.discover_author!
    page.learn
    puts "state:#{page.author_state},  url:#{page.url}"
    page.save
  end
end
