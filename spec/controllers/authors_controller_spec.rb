describe AuthorsController, :type => :controller do
  let(:me) { create!(:user) }

  it 'can view author settings' do
    get_with me, :settings
  end

  it 'can ask about an author' do
    get :enquire, provider:'facebook', username:'scott.fryxell'
  end

end
