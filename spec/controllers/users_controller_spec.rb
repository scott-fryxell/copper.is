describe UsersController, :type => :controller do
  let(:me) { create!(:user) }

  it 'can view user settings' do
    get_with me, :settings
  end

  it 'can view a user profile' do
    get :show, id:me.id
  end

  it 'can update a user' do
    put_with me, :update, id:me.id
  end

end
