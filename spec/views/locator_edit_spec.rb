require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "the view for editing an existing URL" do
  it "should render properly" do
    url = mock_model(Locator)
    url.should_receive(:scheme)
    url.should_receive(:userinfo)
    url.should_receive(:host)
    url.should_receive(:port)
    url.should_receive(:registry)
    url.should_receive(:path)
    url.should_receive(:opaque)
    url.should_receive(:query)
    url.should_receive(:fragment)
    assigns[:locator] = url

    render '/locators/edit'
    response.should have_tag('aside')
  end
end