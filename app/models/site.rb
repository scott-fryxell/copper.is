class Site < ActiveRecord::Base
  include STIFactory
  has_many :pages
  attr_accessible :name
  
  def find_author!(page)
    page.reject!
    save!
  end
end
