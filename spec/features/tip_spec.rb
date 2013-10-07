require File.dirname(__FILE__) + '/../spec_helper'

describe "Tipping a page", :slow do

  describe "as a fan" do
    before(:each) do
      mock_page_and_user
      visit "/auth/facebook"
      visit "/test"
      click_on "Copper."
    end

    it "can display the tipped pages title" do
      sleep 3
      page.save_screenshot('tmp/screenshots/tip/01.png')
      page.should have_selector('#copper_tip')
      within_frame('copper') do
        page.should have_content("Thank You!")
        page.should have_content("You just tipped")

        page.should have_content("75")
        page.should have_content("Close")
      end
      User.first.tips.count.should == 1
    end

  end

  describe "as a guest" do
    before(:each) do
      mock_page_and_user
      visit "/test"
      click_on "Copper."
    end

    it "can see a service invite" do
      page.should have_selector('#copper_tip')
      page.save_screenshot('tmp/screenshots/tip/02.png')
      within_frame('copper') do
        page.should have_content("Support creative content")
        page.should have_content("Learn more")
        page.should have_content("Close")
      end
      Tip.count.should == 0
    end

    it "should be able to dismiss layover by clicking X" do
      within_frame('copper') do
        click_on("Close")
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
