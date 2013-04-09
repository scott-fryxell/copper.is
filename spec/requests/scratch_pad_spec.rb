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
    it "has a homepage to start working from" do 
      visit "/admin"
      page.save_screenshot('tmp/screenshots/scratch/01.png')
      # save_and_open_page
      page.should have_css('section#admin > header > nav', visible:true)
    end
  end


end