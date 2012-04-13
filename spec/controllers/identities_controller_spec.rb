require 'spec_helper'

describe IdentitiesController do
  describe 'as Guest' do
    before :all do
      # delete '/sessions'
    end
    it 'index'
    it 'new'
    it 'create'
    it 'show'
    it 'edit'
    it 'update'
    it 'destroy'
  end
  
  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    it 'index'
    it 'new'
    it 'create'
    it 'show'
    it 'edit'
    it 'update'
    it 'destroy'
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
