module Sites
  class Phony < Site
    def self.match(site)
      site.name == 'test.com' or site.name == 'example.com'
    end
  end
end
