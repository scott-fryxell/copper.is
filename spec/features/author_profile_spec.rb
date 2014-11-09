require 'spec_helper'

describe "An Author", :slow, :type => :feature do
  before :each  do
    mock_page_and_user
    visit '/auth/facebook'
    visit "/author"
  end

  it 'can login with facebook' do
    within '#services figure.facebook > figcaption' do
      page.save_screenshot('tmp/screenshots/author/01.png')
      expect(page).to have_content('facebook.user');
    end

    within '#services' do
      page.execute_script("$('#services > details > summary').trigger('click')")
      expect(page).to have_css('figure.facebook figcaption', visible:true)
      expect(page).to have_css('aside', visible:true)
    end
  end

  it "will always have at least one OAuth service authorized" do
    expect(page).to have_no_css('#services figure form')
  end

  it "can see what OAauth  Copper supports" do
    within '#services' do
      page.execute_script("$('#services > details > summary').trigger('click')")
      expect(page).to have_css('figure > figcaption', visible:true)
      expect(page).to have_css('aside', visible:true)
      expect(page).to have_css('figure > figcaption', visible:false)
      expect(page).to have_css('aside', visible:false)
    end
  end

  it "can authorize multiple " do
    within '#services' do
      expect(page).to have_css('figure', count:1)
      page.execute_script("$('#services > details').attr('open', 'open')")
      page.find('a[title="Authorize twitter"]').click
      expect(page).to have_css('figure', count:2)
    end
  end

  it "can deauthorize a provider" do
    page.execute_script("$('#services > details > summary').trigger('click')")
    within '#services' do
      page.find('a[href="/auth/twitter"]').click
    end
    sleep 1
    page.save_screenshot('tmp/screenshots/author/02.png')
    within 'figure.twitter' do
      click_on 'X'
    end
    expect(page).to have_css('#services figure', count:1)
    expect(page).to have_css('#services figure form', visible:false)
  end

end
