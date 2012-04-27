require 'spec_helper'

describe ChecksController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      describe '/checks' do
        it '302'
      end
    end
    describe 'new' do
      describe '/checks/new' do
        it '302'
      end
    end
    describe 'create' do
      describe 'POST /checks' do
        it '302'
      end
    end
    describe 'show' do
      describe '/checks/:id' do
        it '302'
      end
      describe '/checks/current' do
        it '302'
      end
    end
    describe 'edit' do
      describe '/checks/:id/edit' do
        it '302'
      end
      describe '/checks/current/edit' do
        it '302'
      end
    end
    describe 'update' do
      describe 'PUT /checks/:id' do
        it '302'
      end
      describe 'PUT /checks/current' do
        it '302'
      end
    end
    describe 'destroy' do
      describe 'DELETE /checks/:id' do
        it '302'
      end
      describe 'DELETE /checks/current' do
        it '302'
      end
    end
  end
  
  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    describe 'index' do
      describe '/checks' do
        it 'renders all checks for current user: earned, paid and cashed'
      end
      describe '/checks?s=earned' do
        it 'renders just the current check for the current user'
      end
      describe '/checks?s=paid' do
        it 'renders all paid checks for current user'
      end
      describe '/checks?s=cashed' do
        it 'renders all declined checks for current user'
      end
    end
    describe 'new' do
      describe '/checks/new' do
        it '403'
      end
    end
    describe 'create' do
      describe 'POST /checks' do
        it '403'
      end
    end
    describe 'show' do
      describe '/checks/current' do
        it 'renders the current earned check of current user'
      end
      describe '/checks/:id' do
        it 'renders the given check when owned by current user'
        it '302 to /checks/current if it\'s the current earned check'
        it '403 if check is not owned by current user'
      end
    end
    describe 'edit' do
      describe '/checks/current/edit' do
        it '403'
      end
      describe '/checks/:id/edit' do
        it '403'
      end
    end
    describe 'update' do
      describe 'PUT /checks/current' do
        it 'prepares! the current check for the current user'
        it "doesn't allow any column updates to the check"
      end
      describe 'PUT /tips_orders/:id' do
        it 'prepares! the current check for the current user'
        it '302 to /checks/current if it\'s the current earned check'
        it '403 if not owned by current user'
      end
    end
    describe 'destroy' do
      describe 'DELETE /checks/current' do
        it 'destroys all contained tips, destroys current check and creates a new check'
      end
      describe 'DELETE /checks/:id' do
        it 'if :id is the current check it destroys all contained tips, destroys current check and creates a new check'
        it '403 if check is not current and owned by current user'
        it '403 it check is not current and not owned by current user'
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

