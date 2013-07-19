require 'spec_helper'

describe HomeController do

  describe '/index' do
    it '200' do
      get :index
    end
  end

  describe '/about' do
    it '200' do
      get :about
    end
  end

  describe '/welcome' do
    it '200' do
      get :welcome
    end
  end

  describe '/author' do
    it '200' do
      get :author
    end
  end

  describe '/settings' do
    it '200' do
      get :settings
    end
  end

  describe '/contact' do
    it '200' do
      get :contact
    end
  end

  describe '/terms' do
    it '200' do
      get :terms
    end
  end

  describe '/privacy' do
    it '200' do
      get :privacy
    end
  end

  describe '/iframe' do
    it '200' do
      get :iframe, format:'js'
    end
  end

  describe '/states' do
    it '200' do
      get :states, country_code:'US'
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

  describe '/claim_facebook_pages' do
    it '200' do pending
      mock_user
      @me = create!(:user_with_author)
      post_with @me,  :claim_facebook_pages, facebook_objects:["450082408392770", "328303497281257"]
    end
  end

  describe '/faq' do
    it '200' do
      get :faq
    end
  end

end
