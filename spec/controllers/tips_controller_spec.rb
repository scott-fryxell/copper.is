require 'spec_helper'

describe TipsController,:focus do
  create_me_her_db
  
  describe 'as Guest' do
    before do
      unauthenticate
    end
    
    describe 'index' do
      describe '/t' do
        it 'assigns all tips' do
          get :index
          tips = assigns(:tips)
          tips.should eq([@her_tip2,@her_tip1,@my_tip])
          tips.first.order_id.should be_nil 
          tips.first.check_id.should be_nil
        end
      end
    end
    
    describe 'new' do
      describe '/t/new' do
        it '302 to signin' do
          get :new
          response.should redirect_to(signin_path)
        end
        
        it '401 when json requested' do
          get :new, format: :js
          response.status.should == 401 
        end
      end
    end
    
    describe 'create' do
      describe 'POST /t' do
        it '302 to signin' do
          proc do
            post :create
            response.should redirect_to(signin_path)
          end.should_not change(Tip, :count)
        end
      end
    end
    
    describe 'show' do
      describe '/t/:id' do
        it 'should assign a tip' do
          get :show, id:@my_tip.id
          assigns(:tip).should eq(@my_tip)
          tip = assigns(:tip)
          tip.order_id.should be_nil 
          tip.check_id.should be_nil
        end
      end
    end
    
    describe 'edit' do
      describe '/t/:id/edit' do
        it '302 to signin' do
          get :edit
          response.should redirect_to(signin_path)
        end
        
        it '401 when json requested' do
          get :new, format: :js
          response.status.should == 401 
        end
      end
    end
    
    describe 'update' do
      describe 'PUT /t/:id' do
        it '302 to signin' do
          put :update
          response.should redirect_to(signin_path)
        end
        
        it '401 when json requested' do
          put :update, format: :js
          response.status.should == 401 
        end
      end
    end
    
    describe 'destroy' do
      describe 'DELETE /t/:id' do
        it '302 to signin' do
          proc do
            delete :destroy, id:@my_tip.id
            response.should redirect_to(signin_path)
          end.should_not change(Tip,:count)
        end
        
        it '401 when json requested' do
          proc do
            delete :destroy, format: :js
            response.status.should == 401 
          end.should_not change(Tip,:count)
        end
      end
    end
  end

  describe 'as Patron' do
    before do
      authenticate_as_patron @me
    end
    
    describe 'index' do
      describe '/t' do
        it 'a list of the most recent tips of all users and current user' do
          get :index
          assigns(:tips).should eq([@her_tip2,@her_tip1,@my_tip])
          response.status.should == 200
        end
      end
    end
    
    describe 'new' do
      describe '/t/new' do
        it 'renders a form to specify a url to tip' do
          get :new
          assigns(:tip).new_record?.should be_true
        end
      end
    end
    
    describe 'create' do
      describe 'POST /tips' do
        it 'creates a tip to given url with default amount' do
          post :create, tip:{url:'http://twitter.com/#!/_ugly'}
          Tip.first.page.url.should == 'http://twitter.com/#!/_ugly'
          Tip.first.order.user_id.should == @me.id
        end
      end
      
      describe 'POST /t' do
        it 'creates a tip to given url with given amount' do
          post :create, tip:{url:'http://twitter.com/#!/_ugly', amount_in_cents:100}
          Tip.first.page.url.should == 'http://twitter.com/#!/_ugly'
          Tip.first.amount_in_cents.should == 100
        end
      end
    end
    
    describe 'show' do
      describe '/t/:id' do
        it 'loads my tip' do
          get :show, id:@my_tip.id
          (tip = assigns(:tip)).id.should == @my_tip.id
        end
        
        it 'loads someone else\'s tip' do
          get :show, id:@her_tip1.id
          (tip = assigns(:tip)).id.should == @her_tip1.id
        end
      end
    end
    
    describe 'edit' do
      describe '/t/:id/edit' do
        it 'assigns the given tip' do
          get :edit, id:@my_tip.id
          (tip = assigns(:tip)).id.should == @my_tip.id
        end
      end
    end
    
    describe 'update' do
      describe 'PUT /t/:id' do
        it 'update the amount of the tip' do
          put :update, id:@my_tip.id, tip:{amount_in_cents:200}
          @my_tip.reload
          @my_tip.amount_in_cents.should == 200
        end
        
        it 'does not update a non-promised tip' do
          put :update, id:@my_tip.id, tip:{amount_in_cents:200}
          @my_tip.reload
          @my_tip.amount_in_cents.should == 200
        end
        
        it 'does not update a her tip' do
          put :update, id:@her_tip2.id, tip:{amount_in_cents:200}
          @her_tip2.reload
          @her_tip2.amount_in_cents.should_not == 200
          response.status.should == 401
        end
      end
    end
    
    describe 'destroy' do
      describe 'DELETE /t/:id' do
        it 'destroys a promised tip' do
          proc do
            delete :destroy, id:@my_tip.id
            proc{Tip.find(@my_tip.id).should be_nil}.should raise_error(ActiveRecord::RecordNotFound)
          end.should change(Tip, :count)
        end
        
        it '403 a :charged tip' do
          proc do
            @my_tip.pay!
            @my_tip.reload
            delete :destroy, id:@my_tip.id
            Tip.find(@my_tip.id).should_not be_nil
          end.should_not change(Tip, :count)
        end
        
        it '403 a :kinged tip' do
          proc do
            order = @me.current_order
            @me.current_order.rotate!
            order.reload
            Stripe::Charge.stub(:create) { OpenStruct.new(id:1) }
            order.charge!
            @my_tip.reload
            @my_tip.check_id = 1
            @my_tip.claim!
            @my_tip.kinged?.should be_true
            delete :destroy, id:@my_tip.id
            Tip.find(@my_tip.id).should_not be_nil
          end.should_not change(Tip, :count)
        end
        
        it '403 her tip' do
          proc do
            delete :destroy, id:@her_tip1.id
            Tip.find(@her_tip1.id).should_not be_nil
          end.should_not change(Tip, :count)
        end
      end
    end
  end

  describe 'as Admin' do
    before do
      authenticate_as_admin
    end
    
    describe 'index' do
      it 'should be tested'
    end
    
    describe 'new' do
      it 'should be tested'
    end
    
    describe 'create' do
      it 'should be tested'
    end
    
    describe 'show' do
      it 'should be tested'
    end
    
    describe 'edit' do
      it 'should be tested'
    end
    
    describe 'update' do
      it 'should be tested'
    end
    
    describe 'destroy' do
      it 'should be tested'
    end
  end
end
