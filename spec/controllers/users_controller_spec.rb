require 'spec_helper'

describe UsersController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      describe '/users' do
        it 'renders a list of featured users'
      end
      describe '/users?q=mike' do
        it 'does a search for a user with \'mike\' in their name'
      end
    end
    describe 'new' do
      describe '302'
    end
    describe 'create'do
      describe '302'
    end
    describe 'show' do
      describe '/users/:id' do
        it 'renders the profile page of the given user'
      end
      describe '/users/:id' do
        it '302 for a user who does not want to be known'
      end
    end
    describe 'edit' do
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
      describe '/users' do
        it 'renders a list of featured users'
      end
      describe '/users?q=mike' do
        it 'does a search for a user with \'mike\' in their name'
      end
    end
    describe 'new' do
      describe '/users/new' do 
        it '403'
      end
    end
    describe 'create' do
      describe 'POST /users' do
        it '403'
      end
    end
    describe 'show' do
      describe '/users/:id' do
        it 'renders a profile page a given user'
      end
    end
    describe 'edit' do
      describe '/users/current/edit' do
        it 'renders a account page'
      end
      describe '/users/:id/edit' do
        it '403'
      end
    end
    describe 'update' do
      describe 'POST /users/current' do 
        it 'updates email'
      end
      describe 'POST /users/current' do
        it 'updates default tip amount'
      end
    end
    describe 'destroy' do
      describe 'DELETE /users/current' do
        it 'deactivates the account of the current user only'
      end
      describe 'DELETE /users/:id' do 
        it '403'
      end
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
    describe 'edit'
    describe 'update'
    describe 'destroy'
  end
end
