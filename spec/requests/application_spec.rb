require File.dirname(__FILE__) + '/../spec_helper'

describe "The standard Weave page" do
  before(:each) do
    visit "/"
    # request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
  end

  it "should contain a global nav section" do
    page.has_selector? "body > header"
  end

  it "should contain a courtesy nav section" do
    page.has_selector? "body > footer"
  end
  
  it "should contain a content area" do
    page.has_selector? "body > section"
  end

  describe "global navigation" do

    it "should link to the blog" do
      page.has_selector? "#blog"
    end
    
    it "should contain a logo" do
      page.has_selector? "body > header > a"
    end

  end
  
  describe "courtesy navigation" do
    it "should provide a way to email the company" do
      page.has_selector? "#contact"
      page.has_selector? "#lame"
    end
    
    it "should link to a page that describes the Terms & Conditions for the service" do
      page.has_selector? "html > body > footer > nav > a[href='/terms']"
    end
    
    it "should link to a page that describes the privacy policy for the service" do
      page.has_selector? "html > body > footer > nav > a[href='/privacy']"
    end
    
  end
end