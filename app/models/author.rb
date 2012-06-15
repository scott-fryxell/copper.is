class Author < ActiveRecord::Base
  has_paper_trail
  has_many :pages
  has_many :auth_sources
  
  def merge!(rhs)
    self.auth_sources += rhs.auth_sources
    self.pages += rhs.pages
    save!
    # rhs.destroy
    self
  end
end
