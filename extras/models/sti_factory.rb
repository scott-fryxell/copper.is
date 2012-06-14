module STIFactory
  def factory
    self.type.constantize.find(self.id) # TODO do this without a DB hit
  end
  
  def self.included(base)
    def base.inherited(child)
      children << child  
      super
    end
    
    def base.children
      @children ||= []
    end
    
    def base.type_reset(this)
      this.type = self.to_s
    end
    
    def base.type_reset!(this)
      type_reset(this)
      this.save!
    end
    
    def base.type_reset?(this)
      type_reset(this) if match?(this)
    end
    
    base.before_create do |this|
      this.class.children.find do |child|
        child.type_reset?(this)
      end
      true
    end
  end
end
