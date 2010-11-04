require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  it "should have a terms page" do
    get :terms
    response.should render_template('terms')
  end

  it "should have a privacy page" do
    get :privacy
    response.should render_template('privacy')
  end

  it "should have a contact page" do
    get :contact
    response.should render_template('contact')
  end

  it "should have a subscribe page" do
    get :subscribe
    response.should render_template('subscribe')
  end
end