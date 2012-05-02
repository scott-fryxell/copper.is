require File.dirname(__FILE__) + '/../spec_helper'

describe "Tiping a URL" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
  end

  it "should be able to tip through the extension" do
    tip_twitter
  end

  it "should be able to update a tip" do
    tip_twitter
    click_on('Change')
    fill_in('tip_amount', :with => '1.5')
    click_on('save')
  end

  it "should be able to buck from the fans bucks page" do
    click_link 'fan'
    click_link 'tips'
    fill_in('tip[uri]', :with => 'http://www.bigtest.com')
    click_on('TIP')
    page.should have_content 'Tip successfully created.'
    page.should have_content 'http://www.bigtest.com'
  end

  slow_test do
    it "should be able to delete a buck " do
      tip_twitter
      visit "/users/current/tips"
      page.should have_content 'copper_dev'
      click_on('x')
      sleep 2
      visit "/users/current/tips"
    end
  end

  slow_test do
    describe "paying for some tips" do
      before do
        tip_twitter
        click_on('Change')
        fill_in('tip_amount', :with => '10.5')
        click_on('save')
        sleep 2
        tip_twitter
      end

      it "should be notified that it's time to pay" do
        page.should have_content "Let's take care of some business"
      end

      it "should be able to pay for tips" do
        sleep 2
        fill_in('email', :with => 'google_user@email.com')
        fill_in('number', :with => '4242424242424242')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        click_on('Pay')
        page.should have_content "Processing your order..."
        sleep 5
        page.should have_content "Success! We've emailed you a reciept"
      end

      it "should be able to view all their tips" do
        sleep 2
        fill_in('email', :with => 'google_user@email.com')
        fill_in('number', :with => '4242424242424242')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        click_on('Pay')
        page.should have_content "Processing your order..."
        sleep 5
        page.should have_content "Success! We've emailed you a reciept"

        visit('/users/current')
        click_on('tips')
        click_on('All')
      end

      it "should decline a credit card without funds" do
        sleep 2
        fill_in('email', :with => 'google_user@email.com')
        fill_in('number', :with => '4000000000000002')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        click_on('Pay')
        page.should have_content "Processing your order..."
        sleep 5
        page.should have_content "Your card was declined."
      end

      it "should charge a user twice." do

        sleep 2
        fill_in('email', :with => 'google_user@email.com')
        fill_in('number', :with => '4242424242424242')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        click_on('Pay')
        page.should have_content "Processing your order..."
        sleep 5
        page.should have_content "Success! We've emailed you a reciept"
        tip_twitter
        click_on('Change')
        fill_in('tip_amount', :with => '10.5')
        click_on('save')
        sleep 2
        tip_twitter

        sleep 2
        fill_in('email', :with => 'google_user@email.com')
        fill_in('number', :with => '4242424242424242')
        fill_in('cvc', :with => '666')
        select('April', :from => 'month')
        select('2015', :from => 'year')
        check('terms')
        click_on('Pay')
        page.should have_content "Processing your order..."
        sleep 5
        page.should have_content "Success! We've emailed you a reciept"
      end
    end
  end
end
