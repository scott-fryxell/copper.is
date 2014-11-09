require 'spec_helper'

describe "Tipping a page", :slow, :type => :feature do

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
      expect(page).to have_selector('#copper_tip')
      within_frame('copper') do
        expect(page).to have_content("Thank You!")
        expect(page).to have_content("You just tipped")

        expect(page).to have_content("75")
        expect(page).to have_content("Close")
      end
      expect(User.first.tips.count).to eq(1)
    end

  end

  describe "as a guest" do
    before(:each) do
      mock_page_and_user
      visit "/test"
      click_on "Copper."
    end

    it "can see a service invite" do
      expect(page).to have_selector('#copper_tip')
      page.save_screenshot('tmp/screenshots/tip/02.png')
      within_frame('copper') do
        expect(page).to have_content("Support creative content")
        expect(page).to have_content("Learn more")
        expect(page).to have_content("Close")
      end
      expect(Tip.count).to eq(0)
    end

    it "should be able to dismiss layover by clicking X" do
      within_frame('copper') do
        click_on("Close")
        expect(page).to have_css('section.sign_in', visible:false)
      end
    end

    it "should be able to learn more about the service" do
      within_frame('copper') do
        click_on("Learn more")
        expect(page).to have_css('section.sign_in', visible:false)
      end
    end

  end
end
