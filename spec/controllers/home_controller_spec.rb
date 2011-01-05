require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  it "should have an index page" do
    get :index
    response.should render_template('index')
  end

end