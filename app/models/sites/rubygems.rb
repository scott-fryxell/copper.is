module Sites
  class Rubygems < Site
    def self.match?(site)
      site.name == 'rubygems.org'
    end
    
    def find_author!(page)
      raise 'TBD'
    end
  end
end
