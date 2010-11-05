require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SupportController do
  it "should have a home page" do
    get :home
    response.should render_template('home')
  end

  it "should have a compromised account action" do
    get :compromised_account
    response.should render_template('compromised_account')
  end
end