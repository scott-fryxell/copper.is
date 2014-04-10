def mock_page
  Page.any_instance.stub(:learn)
  Page.any_instance.stub(:discover_author!)
end

def mock_order
  Order.any_instance.stub(:send_paid_order_message)
end

def mock_user
  User.any_instance.stub(send_welcome_message:[{"email"=> "scott@copper.is","status" => "sent"}])
  Author.any_instance.stub(:create_page_for_author)
end

def mock_page_and_user
  mock_page
  mock_user
end

class OpenStruct
  def to_json(*args)
    table.to_json
  end
end

class Stripe::Customer
  # def self.create(*args)
  #   puts "create #{args}"
  #   OpenStruct.new(id:'1', :active_card=>{type:'Visa', exp_year:'2015', exp_month:'4', last4:"4242"})
  # end
  def self.retrieve(*args)
    # puts "retrieve #{args}"
    OpenStruct.new(id:'1', save:"", :active_card=>{type:'Visa', exp_year:'2015', exp_month:'4', last4:"4242"})
  end
end

class Stripe::Charge
  def self.create(*args)
    # puts "charge #{args}"
    OpenStruct.new(id:'1', :card => {last4:'4242'})
  end
end

# Twitter.stub(:update)
