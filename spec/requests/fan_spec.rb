require File.dirname(__FILE__) + '/../spec_helper'

describe "A Fan" do
  before(:each) do
    visit "/"
    click_link 'google_sign_in'
  end
  
  describe "signing in" do
    before(:each) do
      visit '/signout'
    end
    
    it "should have access to a signin link" do
      visit "/"
      # page.should have_content 'Sign In With'
      page.has_selector? "body > header > hgroup > nav > a[href='/auth/twitter']"
    end

    it "should be able to login via facebook" do
      visit "/"
      page.has_selector? "body > header > hgroup > nav > a[href='/auth/facebook']"
    end

    it "should be able to login via Google" do
      visit "/"
      page.has_selector? "body > header > hgroup > nav > a[href='/auth/google']"
    end

    it "should login with twitter",:broken do
      visit "/"
      click_link 'twitter_sign_in'
      page.should have_content 'twitter user'
      # page.should have_content 'Welcome aboard!'
    end

    it "should login with facebook" do
      visit "/"
      click_link 'facebook_sign_in'
      page.should have_content 'facebook user'
      # page.should have_content 'Welcome aboard!'
    end

    it "should login with google" do
      visit "/"
      click_link 'google_sign_in'
      page.should have_content 'google user'
      # page.should have_content 'Welcome aboard!'
    end

    it "should be able to log in multiple times" do
      visit "/"
      click_link 'google_sign_in'
      click_link 'signout'
      click_link 'google_sign_in'
      page.should have_content 'Signed in!'
    end

    it  "should be able to sign out" do
      visit "/"
      click_link 'google_sign_in'
      click_link 'signout'
      page.should have_content 'Signed out'
    end

  end

  describe "tipping", :broken do
    it "should be able to load the tip iframe javascript" do
      visit "/embed_iframe.js"
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


    slow_test do
      it "should be able to delete a tip " do
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

  describe "updating account info" do
    it "should have some tips to look at" do
      click_link 'fan'
      click_link 'tips'
      page.should have_content 'Tips'
    end

    it "should be able to change tip rate" do
      click_link 'fan'
      click_link 'tips'
      find_field('user[tip_preference_in_cents]').value.should == '50'
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_link 'fan'
      click_link 'tips'
      find_field('user[tip_preference_in_cents]').value.should == '100'
    end

    describe "should be able to change email" do
      it "and submit by clicking on 'Save'" do
        click_link 'fan'
        # find_field('user[email]').value.should == 'user@google.com'
        fill_in('user[email]', :with => 'change@google.com')
        within("section#email") do
          click_on 'Save'
        end
        
        click_link 'fan'
        find_field('user[email]').value.should == 'change@google.com'
        
        fill_in('user[email]', :with => 'user@google.com')
        within("section#email") do
          click_on 'Save'
        end
      end

    end

    describe "should be able to change name" do
      before do
        click_link 'fan'
        find_field('user[name]').value.should == 'google user'
        fill_in('user[name]', :with => 'joe fan')
      end

      after do
        click_link 'fan'
        fill_in('user[name]', :with => 'joe fan')
      end

      it "and submit by clicking on 'Save'" do
        within("section#name") do
          click_on 'Save'
        end
        click_link 'fan'
        find_field('user[name]').value.should == 'joe fan'
      end

    end

    it "should only be able to change name to a valid email address" do
      click_link 'fan'
      find_field('user[email]').value.should == 'user@google.com'
      fill_in('user[email]', :with => 'bademailaddress')
      within("section#email") do
        click_on 'Save'
        page.should have_content 'invalid email'
        fill_in('user[email]', :with => 'change2@google.com')
        click_on 'Save'
      end
      click_link 'fan'
      find_field('user[email]').value.should == 'change2@google.com'
    end

  end
end
