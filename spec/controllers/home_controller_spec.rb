require 'spec_helper'

describe HomeController do

  describe '/index' do
    it '200' do
      get :index
    end
  end

  #TODO belongs in users_controller
  describe '/claim_facebook_pages' do
    it '200' do pending
      mock_user
      @me = create!(:user_with_author)
      post_with @me,  :claim_facebook_pages, facebook_objects:["450082408392770", "328303497281257"]
    end
  end

  #TODO:  belongs in tips controller
  describe '/iframe' do
    it '200' do
      get :iframe, format:'js'
    end
  end

  describe '/ping' do
    it '200' do
      get :ping
    end
  end

  describe '/test' do
    it '200' do
      get :test
    end
  end

end
