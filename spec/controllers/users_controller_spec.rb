require 'spec_helper'

describe UsersController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      it '/users renders a list of featured users'
    end
    describe 'new' do
      it '302'
    end
    describe 'create'do
      it '302'
    end
    describe 'show' do
      it '/users/:id renders the profile page of the given user'
      it '/users/:id 302 for a user who does not want to be known'
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
      it 'renders a list of featured users'
    end
    describe 'new' do
      it '403'
    end
    describe 'create' do
      it '403'
    end
    describe 'show' do
      it '/users/:id renders a profile page a given user'
    end
    describe 'edit' do
      it '/users/current/edit renders a account page'
      it '/users/:id/edit 403'
    end
    describe 'update' do
      it 'POST /users/current updates email'
      it 'POST /users/current updates default tip amount'
    end
    describe 'destroy' do
      it 'DELETE /users/current deactivates the account of the current user only'
      it 'DELETE /users/:id 403'
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
