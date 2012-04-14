require 'spec_helper'

describe RoyaltyChecksController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      describe '/royalty_checks' do
        it '302'
      end
    end
    describe 'new' do
      describe '/royalty_checks/new' do
        it '302'
      end
    end
    describe 'create' do
      describe 'POST /royalty_checks' do
        it '302'
      end
    end
    describe 'show' do
      describe '/royalty_checks/:id' do
        it '302'
      end
      describe '/royalty_checks/current' do
        it '302'
      end
    end
    describe 'edit' do
      describe '/royalty_checks/:id/edit' do
        it '302'
      end
      describe '/royalty_checks/current/edit' do
        it '302'
      end
    end
    describe 'update' do
      describe 'PUT /royalty_checks/:id' do
        it '302'
      end
      describe 'PUT /royalty_checks/current' do
        it '302'
      end
    end
    describe 'destroy' do
      describe 'DELETE /royalty_checks/:id' do
        it '302'
      end
      describe 'DELETE /royalty_checks/current' do
        it '302'
      end
    end
  end
  
  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    describe 'index' do
      describe '/royalty_checks' do
        it 'renders all royalty_checks for current user: earned, paid and cashed'
      end
      describe '/royalty_checks?s=earned' do
        it 'renders just the current royalty_check for the current user'
      end
      describe '/royalty_checks?s=paid' do
        it 'renders all paid royalty_checks for current user'
      end
      describe '/royalty_checks?s=cashed' do
        it 'renders all declined royalty_checks for current user'
      end
    end
    describe 'new' do
      describe '/royalty_checks/new' do
        it '403'
      end
    end
    describe 'create' do
      describe 'POST /royalty_checks' do
        it '403'
      end
    end
    describe 'show' do
      describe '/royalty_checks/current' do
        it 'renders the current earned royalty_check of current user'
      end
      describe '/royalty_checks/:id' do
        it 'renders the given royalty_check when owned by current user'
        it '302 to /royalty_checks/current if it\'s the current earned royalty_check'
        it '403 if royalty_check is not owned by current user'
      end
    end
    describe 'edit' do
      describe '/royalty_checks/current/edit' do
        it '403'
      end
      describe '/royalty_checks/:id/edit' do
        it '403'
      end
    end
    describe 'update' do
      describe 'PUT /royalty_checks/current' do
        it 'prepares! the current royalty_check for the current user'
        it "doesn't allow any column updates to the royalty_check"
      end
      describe 'PUT /tips_orders/:id' do
        it 'prepares! the current royalty_check for the current user'
        it '302 to /royalty_checks/current if it\'s the current earned royalty_check'
        it '403 if not owned by current user'
      end
    end
    describe 'destroy' do
      describe 'DELETE /royalty_checks/current' do
        it 'destroys all contained tips, destroys current royalty_check and creates a new royalty_check'
      end
      describe 'DELETE /royalty_checks/:id' do
        it 'if :id is the current royalty_check it destroys all contained tips, destroys current royalty_check and creates a new royalty_check'
        it '403 if royalty_check is not current and owned by current user'
        it '403 it royalty_check is not current and not owned by current user'
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
    describe 'eddescribe'
    describe 'update'
    describe 'destroy'
  end
end

