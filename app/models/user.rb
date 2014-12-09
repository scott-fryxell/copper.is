class User < ActiveRecord::Base
  include Enqueueable
  include Historicle
  include Message::Onboardable

  has_many :authors
  has_many :orders
  has_many :tips, :through => :orders
  has_many :pages, :through => :tips
  has_many :checks
  has_and_belongs_to_many :roles

  scope :tipped,       -> { joins(:tips) }
  scope :payment_info, -> { where('stripe_id IS NOT NULL') }

  validates :tip_preference_in_cents,
    :numericality => { greater_than_or_equal_to:Tip::MINIMUM_TIP_VALUE },
    :presence => true
  validates :name, length:{in:3..128}, allow_nil:true

  # EMAIL_RE = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  # validates :email, format:{with:EMAIL_RE}, allow_nil:true
  # TODO: reset this validation

  validate :validate_one_current_order, on:'save'
  def validate_one_current_order
    errors.add(:orders, "there must be only one") unless self.orders.current.size == 1
  end

  after_create do |user|
    create_current_order!
    Resque.enqueue user.class, user.id, :send_welcome_message
  end

  def self.create_from_authorizer auth
    create! do |user|
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.roles << Role.find_by(name:'fan')
    end
  end


  def create_current_order!
    if self.orders.unpaid.count > 0
      raise "there is already an unpaid Order for this user: #{self.inspect}"
    end
    self.orders.create!
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def paid_royalties
    Tip.given.where(page_id:authored_pages.pluck(:id))
  end

  def pending_royalties
    Tip.paid.where(page_id:authored_pages.pluck(:id))
  end

  def royalties
    Tip.where(page_id:authored_pages.pluck(:id))
  end

  def average_royalties_in_cents
    royalties = Tip.where(page_id:authored_pages.pluck(:id)).average(:amount_in_cents)
    royalties = 0 unless royalties
    royalties.round
  end

  def authored_pages
    Page.where(author_id: author_ids).includes(:tips)
  end

  def tipped_pages
    pages.group('pages.id').includes(:tips).except(:order).order('MAX(tips.created_at) DESC')
  end

  def tip args = {}

    tip = current_order.tips.build()

    tip.page = Page.find_or_create_by url:args[:url]

    tip.amount_in_cents = args[:amount_in_cents] || tip_preference_in_cents

    tip.save!

    tip
  end

  def current_order
    self.orders.current.first or self.orders.create
  end

  def try_to_create_check!
    the_tips = []
    self.authors.each do |ident|
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

end
