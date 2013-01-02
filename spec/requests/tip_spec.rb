require File.dirname(__FILE__) + '/../spec_helper'

describe "tipping a page", :slow do
  after(:each) do
    page.driver.error_messages.size.should == 0
  end


  describe "as a fan" do
    before(:each) do
      visit "/"
      click_link 'facebook_sign_in'
      visit "/test"
      ResqueSpec.reset!
      ResqueSpec.inline = false
    end

    after(:each) do
      ResqueSpec.reset!
      ResqueSpec.inline = true
    end

    it "should display the tipped pages title" do
      page.should have_selector('#copper')
      within_frame('copper') do
        page.execute_script("jQuery.fx.off = true")
        page.should have_content("copper-test page")
        page.should have_content("0.75")
      end
      User.first.tips.count.should == 1
    end

    it "should be able to update a tip"
  end

  describe "as a guest", :broken do
    before(:each) do
      visit "/test"
    end

    it "should see a service invite" do
      page.should have_selector('#copper')
      within_frame('copper') do
        page.execute_script("jQuery.fx.off = true")
        page.should have_content("copper-test page")
        page.should have_content("You Can Tip")
        page.should have_content("Learn more")
        page.should have_content("X")
      end
      Tip.count.should == 0
    end

    it "should be able to dismiss layover" do
      within_frame('copper') do
        click_on("X")
        page.should have_css('section.sign_in', visible:false)
      end
    end

    it "should be able to learn more about the service" do
      within_frame('copper') do
        click_on("Learn more")
        page.should have_css('section.sign_in', visible:false)
      end
    end
 
  end
end
