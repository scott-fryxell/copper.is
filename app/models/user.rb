class User < ActiveRecord::Base
  include Enqueueable
  has_one  :address
  has_many :identities
  has_many :orders
  has_many :tips, :through => :orders
  has_many :checks
  has_and_belongs_to_many :roles
  has_paper_trail

  attr_accessible :name, :email, :tip_preference_in_cents, :accept_terms, :payable_to, :line1, :line2, :city, :postal_code, :country_code, :subregion_code

  validates :tip_preference_in_cents,
    :numericality => { greater_than_or_equal_to:Tip::MINIMUM_TIP_VALUE },
    :presence => true
  validates :name, length:{in:3..128}, allow_nil:true

  # this doesn't match gmail '+' tags
  EMAIL_RE = /^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
  validates :email, format:{with:EMAIL_RE}, :allow_nil => true

  validate :validate_one_current_order, on:'save'
  def validate_one_current_order
    errors.add(:orders, "there must be only one") unless self.orders.current.size == 1
  end

  after_create :create_current_order!

  def create_current_order!
    if self.orders.unpaid.count > 0
      raise "there is already an unpaid Order for this user: #{self.inspect}"
    end
    self.orders.create!
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.roles << Role.find_by_name('Fan')
    end
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def fan?
    roles.find{|e| e.name == 'Fan'}
  end

  def tip(args = {})
    url    = args[:url]
    amount_in_cents = args[:amount_in_cents] || self.tip_preference_in_cents
    title  = CGI.unescapeHTML(args[:title])  if args[:title]
    thumbnail_url = args[:thumbnail_url]
    
    tip = current_order.tips.build(amount_in_cents:amount_in_cents)
    unless tip.page = Page.where('url = ?', url).first
      tip.page = Page.create(url:url,title:title,thumbnail_url:thumbnail_url)
    end
    tip.save!
    tip
  end

  def charge_info?
    !!self.stripe_id
  end

  def current_order
    self.orders.current.first or self.orders.create
  end

  def current_tips
    current_order.tips
  end

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

  def message_about_check(check_id)
    CheckMailer.check(Check.find(check_id)).deliver
  end
end
