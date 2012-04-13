require 'spec_helper'

describe TipsController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      it 'renders a list of the most recent tips'
    end
    describe 'new' do
      it '302'
    end
    describe 'create' do
      it '302'
    end
    describe 'show' do
      it 'renders a given tip'
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
      it '/tips renders a list of the most recent tips of all users and current user'
      it '/tips_orders/:id/tips renders a list of all tips in :current tip_order for current user'
      it '/tips_orders/:id/tips renders a list of all tips in given :ready tip_order'
      it '/tips_orders/:id/tips renders a list of all tips in given :paid tip_order'
      it '/tips_orders/:id/tips renders a list of all tips in given :declined tip_order'
      it '/royalty_checks/:id/tips renders a list of all tips in given :earned royalty_check'
      it '/royalty_checks/:id/tips renders a list of all tips in given :paid royalty_check'
      it '/royalty_checks/:id/tips renders a list of all tips in given :cashed royalty_check'
    end
    describe 'new' do
      it '/tips/new renders a form to specify a url to tip'
    end
    describe 'create' do
      it 'POST /tips creates a tip to given url with default amount'
      it 'POST /tips creates a tip to given url with given amount'
      it 'POST /tips creates a tip to given url with given description'
      it 'POST /tips creates a tip to given url with with amount and given description'
    end
    describe 'show' do
      it '/tips/:id renders a tip view'
    end
    describe 'edit' do
      it '/tips/:id/edit renders a form to edit the amount of tip'
    end
    describe 'update' do
      it 'POST /tips/:id/edit update the amount of the tip'
    end
    describe 'destroy' do
      it 'DELETE /tips/:id destroys a promised tip'
      it '403 a :charged tip'
      it '403 a :received tip'
      it '403 a :cashed tip'
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
