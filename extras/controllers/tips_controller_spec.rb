require 'spec_helper'

describe TipsController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      describe '/tips' do
        it 'renders a list of the most recent tips'
      end
    end
    describe 'new' do
      describe '/tips/new' do
        it '302 to signin'
      end
    end
    describe 'create' do
      describe 'POST /tips' do
        it '302 to signin'
      end
    end
    describe 'show' do
      describe '/tips/:id' do
        it 'renders a given tip'
      end
    end
    describe 'edit' do
      describe '/tips/:id/edit' do
        it '302 to signin'
      end
    end
    describe 'update' do
      describe 'PUT /tips/:id' do
        it '302 to signin'
      end
    end
    describe 'destroy' do
      describe 'DELETE /tips/:id' do
        it '302 to signin'
      end
    end
  end

  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    describe 'index' do
      describe '/tips renders' do
        it 'a list of the most recent tips of all users and current user'
      end
      describe '/tips_orders/current/tips' do
        it 'renders a list of all tips in :current tip_order for current user'
      end
      describe '/tips_orders/:id/tips?s=ready' do
        it 'renders a list of all tips in given :ready tip_order'
      end
      describe '/tips_orders/:id/tips?s=paid' do
        it 'renders a list of all tips in given :paid tip_order'
      end
      describe '/tips_orders/:id/tips?s=declined' do
        it 'renders a list of all tips in given :declined tip_order'
      end
      describe '/royalty_checks/:id/tips?s=ready' do
        it 'renders a list of all tips in given :earned royalty_check'
      end
      describe '/royalty_checks/:id/tips?s=paid' do
        it 'renders a list of all tips in given :paid royalty_check'
      end
      describe '/royalty_checks/:id/tips?s=cashed' do
        it 'renders a list of all tips in given :cashed royalty_check'
      end
    end
    describe 'new' do
      describe '/tips/new' do
        it 'renders a form to specify a url to tip'
      end
    end
    describe 'create' do
      describe 'POST /tips' do
        it 'creates a tip to given url wdescribeh default amount'
      end
      describe 'POST /tips' do
        it 'creates a tip to given url wdescribeh given amount'
      end
      describe 'POST /tips' do
        it 'creates a tip to given url wdescribeh given description'
      end
      describe 'POST /tips' do
        it 'creates a tip to given url wdescribeh wdescribeh amount and given description'
      end
    end
    describe 'show' do
      describe '/tips/:id' do
        it 'renders a tip view'
      end
    end
    describe 'edit' do
      describe '/tips/:id/edit' do
        it 'renders a form to edit the amount of tip'
      end
    end
    describe 'update' do
      describe 'PUT /tips/:id' do
        it 'update the amount of the tip'
      end
    end
    describe 'destroy' do
      describe 'DELETE /tips/:id' do
        it 'destroys a promised tip'
        it '403 a :charged tip'
        it '403 a :received tip'
        it '403 a :cashed tip'
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
