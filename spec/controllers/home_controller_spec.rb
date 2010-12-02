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

  it "should have an index page" do
    get :index
    response.should render_template('index')
  end

  it "it should make a list of tipped pages available to the index page" do
    get :index
    assigns['most_tips'].size.should_not be_nil
  end
end