require 'spec_helper'

describe TipOrdersController do
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
      it 'renders all tip_orders for current user: current, paid and declined'
      it 'with ?state=current, renders just the current tip_order for the current user'
      it 'with ?state=paid, renders all paid tip_orders for current user'
      it 'with ?state=declined, renders all declined tip_orders for current user'
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

