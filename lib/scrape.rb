module Scrape
  def param(uri, param)
    uri = URI.parse(uri)
    uri.query.split('&').each do |p|
      key, value = p.split('=')
      return value if key == param
    end
    nil
  end
end
    
