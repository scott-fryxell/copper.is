require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  fixtures :roles_users, :users, :addresses

  before(:each) do
    @account = Account.new
    @account.user            = users(:email1)
    @account.billing_address = addresses(:missoula)
    @account.billing_name    = "CHOAD T HOCKSLOOGIE"
    @account.expires_on      = Date.new(2013, 4, 1)
    @account.card_type       = CardType.find_by_name('visa')
    @account.number          = 4242_4242_4242_4242
  end

  it "should save if all values are acceptable" do
    @account.save.should be_true
  end

  it "should be associated with a user" do
    @account.user = nil
    @account.save.should be_false
  end

  it "should be associated with a billing address" do
    @account.billing_address = nil
    @account.save.should be_false
  end

  it "should be associated with a billing name" do
    @account.billing_name = nil
    @account.save.should be_false
  end

  it "should be associated with a card type" do
    @account.card_type = nil
    @account.save.should be_false
  end

  it "should have a card number" do
    @account.number = nil
    @account.save.should be_false
  end

  it "should save without a card verification code" do
    @account.verification_code = nil
    @account.save.should be_true
  end

  it "should save with a card verification code" do
    @account.verification_code = 'CVV2'
    @account.save.should be_true
  end

  it "should have a single field for the name from the card" do
    @account.billing_name = "THUNDERBUTT K HORNSWOGGLER"
    @account.save.should be_true
  end

  it "should have a card expiration date" do
    @account.expires_on = nil
    @account.save.should be_false
  end
end
