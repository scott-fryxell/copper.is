require 'spec_helper'

describe OrdersController do
  describe 'as Guest' do
    before :all do
      unauthenticate
    end
    describe 'index' do
      describe '/tip_orders' do
        it '302'
      end
    end
    describe 'new' do
      describe '/tip_orders/new' do
        it '302'
      end
    end
    describe 'create' do
      describe 'POST /tip_orders' do
        it '302'
      end
    end
    describe 'show' do
      describe '/tip_orders/:id' do
        it '302'
      end
      describe '/tip_orders/current' do
        it '302'
      end
    end
    describe 'edit' do
      describe '/tip_orders/:id/edit' do
        it '302'
      end
      describe '/tip_orders/current/edit' do
        it '302'
      end
    end
    describe 'update' do
      describe 'PUT /tip_orders/:id' do
        it '302'
      end
      describe 'PUT /tip_orders/current' do
        it '302'
      end
    end
    describe 'destroy' do
      describe 'DELETE /tip_orders/:id' do
        it '302'
      end
      describe 'DELETE /tip_orders/current' do
        it '302'
      end
    end
  end
  
  describe 'as Patron' do
    before :all do
      authenticate_as_patron
    end
    describe 'index' do
      describe '/tip_orders' do
        it 'renders all tip_orders for current user: current, paid and declined'
      end
      describe '/tip_orders?s=current' do
        it 'renders just the current tip_order for the current user'
      end
      describe '/tip_orders?s=paid' do
        it 'with ?state=paid, renders all paid tip_orders for current user'
      end
      describe '/tip_orders?s=declined' do
        it 'with ?state=declined, renders all declined tip_orders for current user'
      end
    end
    describe 'new' do
      describe '/tip_orders/new' do
        it '403'
      end
    end
    describe 'create' do
      describe 'POST /tip_orders' do
        it '403'
      end
    end
    describe 'show' do
      describe '/tip_orders/current' do
        it 'renders the current open tip_order of current user'
      end
      describe '/tip_orders/:id' do
        it 'renders the given tip_order when owned by current user'
        it '302 to /tip_orders/current if it\'s the current tip_order'
        it '403 if tip_order is not owned by current user'
      end
    end
    describe 'edit' do
      describe '/tip_orders/current/edit' do
        it '403'
      end
      describe '/tip_orders/:id/edit' do
        it '403'
      end
    end
    describe 'update' do
      describe 'PUT /tip_orders/current' do
        it 'prepares! the current tip_order for the current user'
        it "doesn't allow any column updates to the tip_order"
      end
      describe 'PUT /tips_orders/:id' do
        it 'prepares! the current tip_order for the current user'
        it '302 to /tip_orders/current if it\'s the current tip_order'
        it '403 if not owned by current user'
      end
    end
    describe 'destroy' do
      describe 'DELETE /tip_orders/current' do
        it 'destroys all contained tips, destroys current tip_order and creates a new tip_order'
      end
      describe 'DELETE /tip_orders/:id' do
        it 'if :id is the current tip_order it destroys all contained tips, destroys current tip_order and creates a new tip_order'
        it '403 if tip_order is not current and owned by current user'
        it '403 it tip_order is not current and not owned by current user'
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

