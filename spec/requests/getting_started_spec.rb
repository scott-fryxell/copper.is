require File.dirname(__FILE__) + '/../spec_helper'

describe "Getting started page", :slow do
  before(:each) do
    visit "/getting_started"
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it "should have a general description of how to get started", :focus do
    page.should have_css('#any_url', visible:true)
    page.should have_css('#start_tipping', visible:true)
    page.should have_css('#chrome', visible:true)
    
  end
end
