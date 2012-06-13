module Sites
  class Github < Site
    def self.match?(site)
      site.name == 'github.com'
    end
    
    def find_author!(page)
      raises 'TBD'
    end
  end
end
