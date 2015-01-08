class Check < ActiveRecord::Base
  include Enqueueable
  include Historicle
  include Message::Payable

  belongs_to :user
  has_many :tips, :as => :royalties

  validates :user, presence:true

  scope :earned,      -> { where(check_state:'earned') }
  scope :deposited,   -> { where(check_state:'deposited') }
  scope :cashed,      -> { where(check_state:'cashed') }

  state_machine :check_state, :initial => :earned do

    event :deliver do
      transition :earned => :deposited
    end

    event :reconcile do
      transition :deposited => :cashed
    end

  end

end
