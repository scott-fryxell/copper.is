class Site < ActiveRecord::Base
  has_many :pages
  
  attr_accessible :name
  
  @children = Set.new
  
  before_create do |site|
    site.set_child_type
  end
  
  def set_child_type
    Site.children.find do |child|
      if child.match(self)
        self.type = child.to_s
      end
    end
  end
  
  def self.inherited(child)
    @children << child
  end
  
  def self.children
    @children
  end
end

require 'sites/phony' # TODO eliminate this
