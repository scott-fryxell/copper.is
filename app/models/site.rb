class Site < ActiveRecord::Base
  has_many :pages
  
  attr_accessible :name
  
  @children = Set.new
  
  after_create do
    Site.set_child_type(self)
  end
  
  def self.set_child_type(site)
    @children.find do |child|
      if child.match(site)
        site.type = child.class.to_s
      end
    end
    site.save!
  end
  
  def self.inherited(child)
    @children << child
  end
  
  def self.children
    @children
  end
end

require 'sites/phony'
