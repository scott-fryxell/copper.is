class TipOrderMissing < Exception ; end

class TipOrder < ActiveRecord::Base
  has_many :tips

  belongs_to :fan, :class_name => "User", :foreign_key => "fan_id"

  validates_presence_of :fan
  
  validates_uniqueness_of :fan_id, :scope => :is_active, :if => :is_active

end
