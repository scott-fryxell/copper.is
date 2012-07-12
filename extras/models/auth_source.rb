class AuthSource < ActiveRecord::Base
  belongs_to :author
  belongs_to :fan
  
  attr_accessible :username
end
