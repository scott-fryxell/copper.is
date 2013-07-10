require File.dirname(__FILE__) + '/../spec_helper'

describe "Author settings", :slow do
  before :each  do
    mock_page_and_user
    visit '/auth/facebook'
    visit "/author"
  end

  it 'should be able to authorize facebook' do
    within '#services figure.facebook > figcaption' do
      page.save_screenshot('tmp/screenshots/author/01.png')
      page.should have_content('facebook.user');
    end

    within '#services' do
      page.execute_script("$('#services > details > summary').trigger('click')")
      page.should have_css('figure.facebook figcaption', visible:true)
      page.should have_css('aside', visible:true)
    end
  end

  it "should always have at least one author authorized" do
    page.should have_no_css('#services figure form')
  end

  it "should be able to show and hide identies that can be added" do
    within '#services' do
      page.execute_script("$('#services > details > summary').trigger('click')")
      page.should have_css('figure > figcaption', visible:true)
      page.should have_css('aside', visible:true)
      page.should have_css('figure > figcaption', visible:false)
      page.should have_css('aside', visible:false)
    end
  end

  it "should be able to authorize multiple authors" do
    within '#services' do
      page.should have_css('figure', count:1)
      page.execute_script("$('#services > details').attr('open', 'open')")
      page.find('a[title="Authorize twitter"]').click
      page.should have_css('figure', count:2)
    end
  end

  it "should be able to deauthorize authors", :broken do
    page.execute_script("$('#services > details > summary').trigger('click')")
    within '#services' do
      page.find('a[href="/auth/twitter"]').click
    end
    sleep 1
    page.save_screenshot('tmp/screenshots/author/02.png')
    within 'figure.twitter' do
      click_on 'X'
    end
    page.should have_css('#services figure', count:1)
    page.should have_css('#services figure form', visible:false)
  end

end
