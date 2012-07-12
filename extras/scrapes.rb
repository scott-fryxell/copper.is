__END__

def try_to_create_check!
  the_tips = []
  self.identities.each do |ident|
    the_tips += ident.tips.charged.all
  end
  unless the_tips.empty?
    if check = self.checks.create
      the_tips.each do |tip|
        check.tips << tip
        tip.claim!
        tip.save!
      end
      check.save!
    end
  end
end
state_machine :author_state, initial: :orphaned do
  event :adopt do
    transition any => :adopted
  end
  
  event :reject do
    transition :orphaned   => :spiderable,
    :spiderable => :manual,
    :manual     => :fostered,
    :fostered   => :orphaned
  end
  
  after_transition any => :orphaned do |page,transition|
    Resque.enqueue Page, page.id, :discover_identity!
  end
  
  after_transition any => :spiderable do |page,transition|
    Resque.enqueue Page, page.id, :find_identity_from_author_link!
  end
  
  after_transition any => :manual do |page,transition|
    Rails.logger.warn "Page set to :manual, id: #{page.id}"
  end
  
  after_transition any => :fostered do |page,transition|
    Rails.logger.warn "Page set to :fostered, id: #{page.id}"
  end
  
  state :orphaned do
    def discover_identity!
      if Identity.provider_from_url(self.url) and
          self.identity = Identity.find_or_create_from_url(self.url)
        adopt!
      else
        reject!
      end
    end
  end
  
  state :spiderable do
    def find_identity_from_author_link!
      author_tag = Nokogiri::HTML(open(self.url)).css('link[rel=author]')
      unless author_tag.blank?
        if author_link = author_tag.attr('href').value                   
          self.identity = Identity.find_or_create_from_url(author_link)
          adopt!
        else
          reject!
        end
      else
        reject!
      end
    end
  end
end
