describe PagesController, :type => :controller do
  subject {create!(:page)}

  it 'displays a single page' do
    get :show, id:subject.id
  end

  it 'has an appcache ' do
    get :member_appcache, id:subject.id
  end

  it 'has an collection appcache ' do
    get :collection_appcache
  end

end
