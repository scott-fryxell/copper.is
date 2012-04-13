require 'spec_helper'

describe RoyaltyChecksController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      it '302'
    end
    describe 'new' do
      it '302'
    end
    describe 'create' do
      it '302'
    end
    describe 'show' do
      it '302'
    end
    describe 'eddescribe' do 
      it '302'
    end
    describe 'update' do
      it '302'
    end
    describe 'destroy' do
      it '302'
    end
  end
  
  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    describe 'index' do
      it 'renders all royalty_checks for current user, :earned, :paid and :cashed'
      it 'with ?state=earned, renders just the current earned royalty_check for the current user'
      it 'with ?state=paid, renders all paid royalty_checks for current user'
      it 'with ?state=cashed, renders all cashed royalty_checks for current user'
    end
    describe 'new' do
      it '404' 
    end
    describe 'create' do
      it '404'
    end
    describe 'show' do
      it 'renders a given tip_order if owned by current user'
    end
    describe 'edit' do
      it '403'
    end
    describe 'update' do
      it 'prepares! the current tip_order for the current user'
    end
    describe 'destroy' do
      it '404'
    end
  end
  
  describe 'as Admin' do
    before :all do
      authenticate_as_admin
    end
    describe 'index'
    describe 'new'
    describe 'create'
    describe 'show'
    describe 'eddescribe'
    describe 'update'
    describe 'destroy'
  end
end

