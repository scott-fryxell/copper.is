class TipOrderMissing < Exception ; end

class TipOrder < ActiveRecord::Base
  has_many :tips

  belongs_to :fan, :class_name => "User", :foreign_key => "fan_id"

  validates_presence_of :fan

  validates_uniqueness_of :fan_id, :scope => :is_active, :if => :is_active

  def charge(token)

    charge = Stripe::Charge.create(
      :amount => self.tips.sum('amount_in_cents') + self.tips.sum('amount_in_cents')/10,
      :currency => "usd",
      :card => token,
      :description => self.fan.email
    )

    # on success rotate order so that no
    # more tips are added to the order
    self.fan.rotate_tip_order!

    self.charge_token = charge.id
    self.save
    
    return charge
  end
end
