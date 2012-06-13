module Sites
  class Soundcloud < Site
    def self.match?(site)
      site.name == 'soundcloud.com'
    end
    
    def find_author!(page)
      raise 'TBD'
    end
  end
end
