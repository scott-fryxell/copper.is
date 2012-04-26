require 'spec_helper'

describe PagesController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      describe '/pages' do
        it 'is tested'
      end
      describe '/pages?q=example.com' do
        it 'is tested'
      end
    end
    describe 'new' do
      describe '/pages/new' do
        it 'is tested'
      end
    end
    describe 'create' do
      describe 'POST /pages' do
        it 'is tested'
      end
    end
    describe 'show' do
      describe '/pages/:id' do
        it 'is tested'
      end
    end
    describe 'edit' do
      describe '/pages/:id/edit' do
        it 'is tested'
      end
    end
    describe 'update' do
      describe 'PUT /pages/:id' do
        it 'is tested'
      end
    end
    describe 'destroy' do
      describe 'DELETE /pages/:id' do
        it 'is tested'
      end
    end
  end
  
  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    describe 'index' do
      describe '/pages' do
        it 'is tested'
      end
      describe '/pages?q=example.com' do
        it 'is tested'
      end
    end
    describe 'new' do
      describe '/pages/new' do
        it 'is tested'
      end
    end
    describe 'create' do
      describe 'POST /pages' do
        it 'is tested'
      end
    end
    describe 'show' do
      describe '/pages/:id' do
        it 'is tested'
      end
    end
    describe 'edit' do
      describe '/pages/:id/edit' do
        it 'is tested'
      end
    end
    describe 'update' do
      describe 'PUT /pages/:id' do
        it 'is tested'
      end
    end
    describe 'destroy' do
      describe 'DELETE /pages/:id' do
        it 'is tested'
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
