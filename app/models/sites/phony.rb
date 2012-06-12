module Sites
  class Phony < Site
    def self.match(site)
      site.name == 'test.com' or site.name == 'example.com'
    end
    
    def find_author!(page)
      username = page.path.sub(%r{^/},'')
      address = username + '@' + self.name
      c = (Channel.where('address = ?', address).first or
           Channel.create!(address:address))
      a = Author.create
      a.channels << c
      a.save!
      page.author = a
      page.save!
      a
    end
  end
end
