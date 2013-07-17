require 'spec_helper'

describe HomeController do
  [:unauthenticate, :authenticate_as_fan, :authenticate_as_admin].each do |method_name|
    # before :all do
    #   send method_name
    # end
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

    describe '/faq' do
      it '200' do
        get :faq
      end
    end
  end
end
