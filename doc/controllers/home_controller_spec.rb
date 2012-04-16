require 'spec_helper'

describe HomeController do
  [:unauthenticate, :authenticate_as_patron, :authenticate_as_admin].each do |method_name|
    before :all do
      send method_name
    end
    describe '/about' do
      it '200' do
        get :about
      end
    end
    describe '/how' do
      it '200' do
        get :how
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
    describe '/button' do
      it '200' do
        get :button 
      end
    end
    describe "/buckingthesystem" do
      it '200' do
        get :index
      end
    end
  end
end
