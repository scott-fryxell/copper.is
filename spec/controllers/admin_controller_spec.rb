require 'spec_helper'
describe AdminController, :type => :controller do

  it 'can view ping page' do
    get :ping
  end

  it 'can view test page' do
    get :test
  end

end
