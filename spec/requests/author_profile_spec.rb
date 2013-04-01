require File.dirname(__FILE__) + '/../spec_helper'

describe "Author settings", :slow do
  before :each  do
    mock_user
    visit '/auth/facebook'
    visit "/author"
  end

  after(:each) do
    page.driver.error_messages.should be_empty
  end

  it 'should be able to authorize facebook' do
    within '#authors > div > figure.facebook > figcaption' do
      page.should have_content('facebook.user');
    end

    within '#services' do
      page.execute_script("$('#services > details > summary').trigger('click')")
      page.should have_css('figure.facebook figcaption', visible:true)
      page.should have_css('aside', visible:true)
    end
  end

  it "should always have at least one author authorized" do
    page.should have_no_css('#authors figure form')
  end

  it "should be able to show and hide identies that can be added" do
    within '#services' do
      page.execute_script("$('#services > details > summary').trigger('click')")
      page.should have_css('figure > figcaption', visible:true)
      # page.should have_css('figure > form', visible:true) #:broken
      page.should have_css('aside', visible:true)

      page.should have_css('figure > figcaption', visible:false)
      # page.should have_css('figure > form', visible:false) #WTF
      page.should have_css('aside', visible:false)
    end
  end

  it "should be able to authorize multible authors" do
    within '#services' do
      page.should have_css('figure', count:1)
      page.execute_script("$('#services > details > summary').trigger('click')")
      click_link 'Authorize twitter'
      page.should have_css('figure', count:2)
    end
  end

  it "should be able to deauthorize authors" do
    within '#services' do
      page.execute_script("$('#services > details > summary').trigger('click')")
      click_link 'Authorize twitter'
    end
    page.should have_css('#authors')
    within 'figure.twitter' do
      click_on 'X'
    end
    page.should have_css('#services figure', count:1)
    page.should have_css('#services figure form', visible:false)
  end
  
end
