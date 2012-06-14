class Author < ActiveRecord::Base
  has_paper_trail
  has_many :pages
  has_many :auth_sources
end
