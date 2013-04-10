require File.dirname(__FILE__) + '/../spec_helper'

describe "some shit that needs doin'", :slow do

  describe "trending content" do 

    it 'a guest can view trending content' do
      visit "/pages"
      page.should have_selector "#pages"
      # page.should have_selector "#pages > figure", count:25
    end

  end

  describe "a admin", :focus, :slow do
    before :each do
      visit "/admin"      
    end

    it "has a homepage to start working from" do 
      page.save_screenshot('tmp/screenshots/scratch/01.png')
      page.should have_css('section > header > nav', visible:true)
    end

    it "can view a list of orders" do 
      click_on "Orders"

      page.should have_css('section#orders', visible:true)
  

    end

  end


end