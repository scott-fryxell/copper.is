describe UsersController, :type => :controller do
  before :each do
    me_setup
  end

  it 'can view user settings' do
    get_with @me, :settings
  end

  it 'can view a user profile' do
    get :show, id:@me.id
  end

  it 'can update a user' do
    put_with @me, :update, id:@me.id
  end

end
