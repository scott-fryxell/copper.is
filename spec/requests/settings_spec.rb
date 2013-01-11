require File.dirname(__FILE__) + '/../spec_helper'

describe "Fan's settings", :slow do
  before(:each) do
    visit "/"
    click_link 'connect with facebook'
    click_link 'Account settings'
    page.execute_script("jQuery.fx.off = true")
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  describe 'Item.js' do
    it "should be able to query items on the page" do
      page.evaluate_script("document.getItems('users')").should_not be_nil
    end

    it "should be able to query for user email" do
      page.evaluate_script("document.copper.me.email").should == "user@facebook.com"
    end

    it "should be able to change email from the command line" do
      within("section#email") do
        find("div > p").should have_content("user@facebook.com")
        page.execute_script("document.copper.me.email = 'change@email.com'")
        page.execute_script("Item.update_page(document.copper.me)")
        find("div > p").should have_content("change@email.com")
        click_link "Change"
        find_field('user[email]').value.should == 'change@email.com'
      end
    end
  end

  it "should have the fan's name in the title" do
    find("head > title").should have_content("facebook user")
  end

  it "should be able to change email" do
    within("#email") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("user@facebook.com")
      click_link "Change"
      page.should have_css('form', :visible => true)
      page.should have_css('div', :visible => false)

      find_field('user[email]').value.should == 'user@facebook.com'
      fill_in('user[email]', :with => 'change@email.com')
      click_on 'Save'
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("change@email.com")
    end
    click_link 'Account settings'
    within("section#email") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("change@email.com")
    end
  end

  it "should be able to change tip amount preference" do
    within("section#rate") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)

      find("div > p").should have_content("0.75")
      click_link "Change"
      page.should have_css('form', :visible => true)
      page.should have_css('div', :visible => false)

      find_field('user[tip_preference_in_cents]').value.should == '75'
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_on "Save"
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("1")
    end
    click_link 'Account settings'
    within("section#rate") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div > p").should have_content("1")
    end
  end

  it 'should add a zero for any tip amount less then a dollar' do
    within("section#rate") do
      find("div > p").should have_content("0.75")
      click_link "Change"
      find_field('user[tip_preference_in_cents]').value.should == '75'
      page.select '$1.00', :from => 'user[tip_preference_in_cents]'
      click_on "Save"
      find("div > p").should have_content("1")
    end
  end

  it "should be able to save their credit card information" do
    within("#card") do
      page.should have_css('form', :visible => true)
      page.should have_css('div', :visible => false)
      fill_in('number', :with => '4242424242424242')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)

      find("div p.number").should have_content("4242")
      find("div p.type").should have_content("Visa")
      find("div p.expiration").should have_content("4/2015")
    end

    within("#card") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div p.number").should have_content("4242")
      find("div p.type").should have_content("Visa")
      find("div p.expiration").should have_content("4/2015")
    end

    click_link 'Account settings'

    within("#card") do
      page.should have_css('form', :visible => false)
      page.should have_css('div', :visible => true)
      find("div p.number").should have_content("4242")
      find("div p.type").should have_content("Visa")
      find("div p.expiration").should have_content("4/2015")
    end
  end

  it "should be told if their credit card info is bad" do
    within("#card") do
      page.should have_css('form', :visible => true)
      fill_in('number', :with => '4000000000000002')
      fill_in('cvc', :with => '666')
      select('April', :from => 'month')
      select('2015', :from => 'year')
      check('terms')
      click_on('Save')
      sleep 3
      page.should have_css('form', :visible => true)
      page.should have_css('form > h1', :visible => true)
      page.should have_content('Your card was declined');
    end
  end


end

describe "Author settings", :slow do
  before :each  do
    visit '/'
    click_link 'connect with facebook'
    visit "/settings"
    click_link 'Author settings'
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it 'should be able to authorize facebook' do
    within '#authors > div > figure.facebook > figcaption' do
      page.should have_content('facebook.user');
    end

    within '#authors' do
      click_link 'Add/Remove'
      page.should have_css('figure.facebook figcaption', visible:true)
      page.should have_css('aside', visible:true)
    end
  end

  it "should always have at least one author authorized" do
    page.should have_no_css('#authors figure form')
  end

  it "should be able to show and hide identies that can be added" do
    within '#authors' do
      click_link 'Add/Remove'
      page.should have_css('figure > figcaption', visible:true)
      # page.should have_css('figure > form', visible:true) #WTF
      page.should have_css('aside', visible:true)

      click_link 'Done'
      page.should have_css('figure > figcaption', visible:false)
      # page.should have_css('figure > form', visible:false) #WTF
      page.should have_css('aside', visible:false)
    end
  end

  it "should be able to authorize multible authors" do
    within '#authors' do
      page.should have_css('figure', count:1)
      click_link 'Add/Remove'
      click_link 'Authorize twitter'
      page.should have_css('figure', count:2)
    end
  end

  it "should be able to deauthorize authors" do
    within '#authors' do
      click_link 'Add/Remove'
      click_link 'Authorize twitter'
      click_link 'Add/Remove'
    end
    page.should have_css('#authors')
    within 'figure.twitter' do
      click_on 'X'
    end
    page.should have_css('#authors figure', count:1)
    page.should have_css('#authors figure form', visible:false)
  end
  
  it 'should be able to change their address' do
    page.should have_css('#address form', visible:true)

    within '#address' do
      click_on 'Save'
      page.should have_css('form', visible:true)

      page.should have_css("input[itemprop=payable_to].invalid")
      page.should have_css("input[itemprop=line1].invalid")
      page.should have_css("input[itemprop=city].invalid")
      page.should have_css("input[itemprop=postal_code].invalid")
      page.should have_css("select[itemprop=country_code].invalid")

      fill_in 'user[payable_to]', with:'joe strummer'
      click_on 'Save'
      page.should have_no_css("input[itemprop=payable_to].invalid", visible:true)

      fill_in 'user[line1]', with:'643 big ass street'
      click_on 'Save'
      page.should have_no_css("input[itemprop=payable_to].invalid", visible:true)

      fill_in 'user[city]', with:'san francisco'
      click_on 'Save'
      page.should have_no_css("input[itemprop=city].invalid", visible:true)

      fill_in 'user[postal_code]', with:'94110'
      click_on 'Save'
      page.should have_no_css("input[itemprop=postal_code].invalid", visible:true)

      fill_in 'user[postal_code]', with:'94110'
      click_on 'Save'
      page.should have_no_css("input[itemprop=postal_code].invalid", visible:true)

      select('United States', :from => 'user[country_code]')
      click_on 'Save'
      page.should have_no_css("select[itemprop=country_code].invalid", visible:true)

      page.should have_css('form', visible:false)      

    end
  end
end
