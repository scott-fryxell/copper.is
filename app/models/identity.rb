class Identity < ActiveRecord::Base
  has_paper_trail
  belongs_to :author
  attr_accessible :site,:user
end
