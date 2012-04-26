require 'spec_helper'

describe IdentitiesController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      describe '/identities' do
        it '302'
      end
      describe '/identities?q=example.com' do
        it '302'
      end
    end
    describe 'new' do
      describe '/identities/new' do
        it '302'
      end
    end
    describe 'create' do
      describe 'POST /identities' do
        it '302'
      end
    end
    describe 'show' do
      describe '/identities/:id' do
        it '302'
      end
    end
    describe 'edit' do
      describe '/identities/:id/edit' do
        it '302'
      end
    end
    describe 'update' do
      describe 'PUT /identities/:id' do
        it '302'
      end
    end
    describe 'destroy' do
      describe 'DELETE /identities/:id' do
        it '302'
      end
    end
  end
  
  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    describe 'index' do
      describe '/identities' do
        it 'is tested'
      end
      describe '/identities?q=example.com' do
        it 'is tested'
      end
    end
    describe 'new' do
      describe '/identities/new' do
        it 'is tested'
      end
    end
    describe 'create' do
      describe 'POST /identities' do
        it 'is tested'
      end
    end
    describe 'show' do
      describe '/identities/:id' do
        it 'is tested'
      end
    end
    describe 'edit' do
      describe '/identities/:id/edit' do
        it 'is tested'
      end
    end
    describe 'update' do
      describe 'PUT /identities/:id' do
        it 'is tested'
      end
    end
    describe 'destroy' do
      describe 'DELETE /identities/:id' do
        it 'is tested'
      end
    end
  end
  
  describe 'as Admin' do
    before :all do
      authenticate_as_admin
    end
    it 'index'
    it 'new'
    it 'create'
    it 'show'
    it 'edit'
    it 'update'
    it 'destroy'
  end
end
