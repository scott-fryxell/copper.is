require 'spec_helper'

describe UsersController do
  describe 'as Guest' do
    create_me_her_db
    
    before do
      unauthenticate
    end
    
    describe 'index' do
      describe '/u' do
        it 'renders a list of featured users'
      end
      
      describe '/u?q=mike' do
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
      describe '/u/:id' do
        it 'renders the profile page of the given user'
      end
      describe '/u/:id' do
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
    before do
      authenticate_as_patron @me
    end
    
    describe 'index' do
      describe '/u' do
        it 'renders a list of featured users'
      end
      describe '/u?q=mike' do
        it 'does a search for a user with \'mike\' in their name'
      end
    end
    
    describe 'new' do
      describe '/u/new' do 
        it '403'
      end
    end
    
    describe 'create' do
      describe 'POST /u' do
        it '403'
      end
    end
    describe 'show' do
      describe '/u/:id' do
        it 'renders a profile page a given user'
      end
    end
    describe 'edit' do
      describe '/u/me/edit' do
        it 'renders a account page'
      end
      describe '/users/:id/edit' do
        it '403'
      end
    end
    describe 'update' do
      describe 'POST /u/me' do 
        it 'updates email'
      end
      describe 'POST /u/me' do
        it 'updates default tip amount'
      end
    end
    describe 'destroy' do
      describe 'DELETE /u/me' do
        it 'deactivates the account of the current user only'
      end
      describe 'DELETE /u/:id' do 
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
