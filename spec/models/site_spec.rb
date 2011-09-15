require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Site do
  fixtures :roles, :users, :roles_users, :pages, :sites, :locators, :tip_orders, :tips

  it "should have a fully-qualified domain name (FQDN)" do
    @site = Site.new
    @site.save.should be_false

    @site.fqdn = 'www.example.com'
    @site.save.should be_true
  end

  it "should not allow the creation of more than one row for a single FQDN" do
    site_one = Site.new(:fqdn => 'www.example.com')
    site_one.save.should be_true

    site_two = Site.new(:fqdn => 'www.example.com')
    site_two.save.should be_false
  end

  it "should respond when asked how many tips it has received" do
    @site = Site.find(sites(:site1))
    @site.tips.should_not be_nil
  end

end
