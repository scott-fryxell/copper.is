require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "the resource view" do
  it "should render properly" do
    resource = mock_model(Resource)
    resource.should_receive(:scheme)
    resource.should_receive(:userinfo)
    resource.should_receive(:host)
    resource.should_receive(:port)
    resource.should_receive(:registry)
    resource.should_receive(:path)
    resource.should_receive(:opaque)
    resource.should_receive(:query)
    resource.should_receive(:fragment)
    assigns[:resource] = resource

    render '/resources/new'
    response.should have_tag('aside')
  end
end