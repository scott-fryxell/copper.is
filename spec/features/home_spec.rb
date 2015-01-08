describe "A guest", :slow, :type => :feature do
  before(:each) do
    visit "/"
  end

  it "will see the welcome page when they first visit copper" do
    # page.response_code.should be(200) :broken
    expect(page).to have_content('Support your favorite artists and easily discover new ones');
    page.save_screenshot('tmp/screenshots/welcome.png')
  end

  it "can not see the fan navigation" do
    expect(page).to have_css('#fan_nav', visible:false)
    expect(page).to have_css('#admin_nav', visible:false)
    expect(page).to have_css('#guest_nav', visible:false)
    expect(page).to have_css('a[href="/auth/facebook"]', visible:true)
    expect(page).to have_css('a[href="/getting_started"]', visible:true)
  end

  it 'sign out and back in' do
    click_link 'Sign in'
    expect(page).to have_css('#fan_nav', visible:true)
    expect(page).to have_css('#guest_nav', visible:false)
    expect(page).to have_css('#admin_nav', visible:false)
    expect(page).to have_css('a[href="/author"]', visible:true)
    expect(page).to have_css('a[href="/settings"]', visible:true)
    expect(page).to have_css('a[href="/signout"]', visible:true)
    click_link 'Sign out of Copper'
  end

end
