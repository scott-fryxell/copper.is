require 'spec_helper'

describe TipsController do
  before :each do
    mock_page_and_user
    me_setup
    # her_setup
  end

  describe 'as Fan' do
    describe 'index' do
      describe '/tips' do
        it 'should respond with 401' do
          get_with @me, :index
          response.status.should == 403
        end
      end
    end

    describe 'new' do
      describe '/tips/new' do
        it 'renders a form to specify a url to tip' do
          get_with @me, :new
          response.status.should == 200
        end
      end
    end

    describe 'create' do
      describe 'POST /tips' do
        it 'creates a tip to given url with default amount' do
          post_with @me, :create, tip:{url:'http://fasterlighterbetter.com'}
          Tip.first.page.url.should == 'http://fasterlighterbetter.com'
          Tip.first.order.user_id.should == @me.id
        end

        it 'creates a tip to given url with given amount' do
          post_with @me, :create, tip:{url:'http://fasterlighterbetter.com', amount_in_cents:100}
          Tip.first.page.url.should == 'http://fasterlighterbetter.com'
          Tip.first.amount_in_cents.should == 100
        end

        it 'creates a tip to given url with given title' do
          post_with @me, :create, tip:{url:'http://fasterlighterbetter.com', title:'dude'}
          Tip.first.url.to_s.should == 'http://fasterlighterbetter.com'
          Tip.first.title.should == 'dude'
        end

        it 'requires a url' do
          post_with @me, :create, tip:{title:'asldkjf'}
          response.status.should == 403
        end
      end
    end

    describe 'show' do
      describe '/tips/:id' do
        it 'loads my tip' do
          get_with @me, :show, id:@my_tip.id
          response.status.should == 403
        end

        it 'loads someone else\'s tip via json' do
          her_setup
          get_with @me, :show, id:@her_tip1.id
          response.status.should == 403
        end
      end
    end

    describe 'update' do
      describe 'PUT /tips/:id' do
        it 'update the amount of the tip' do
          put_with @me, :update, id:@my_tip.id, tip:{amount_in_cents:200}
          response.status.should == 200
          @my_tip.reload
          @my_tip.amount_in_cents.should == 200
        end

        it 'does not update a non-promised tip' do
          put_with @me, :update, id:@my_tip.id, tip:{amount_in_cents:200}
          @my_tip.reload
          @my_tip.amount_in_cents.should == 200
        end

        it 'does not update another fan\'s tip' do
          her_setup
          put_with @me, :update, id:@her_tip2.id, tip:{amount_in_cents:200}
          @her_tip2.reload
          @her_tip2.amount_in_cents.should_not == 200
          response.status.should == 403
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /t/:id' do
        it 'destroys a promised tip' do
          proc do
            @my_tip.promised?.should be_true
            Tip.find(@my_tip.id).should_not be_nil
            delete_with @me, :destroy, id:@my_tip.id
            # proc{Tip.find(@my_tip.id).should be_nil}.should raise_error(ActiveRecord::RecordNotFound)
          end.should change(Tip, :count)
        end

        it '403 a :charged tip' do
          me_setup
          @my_tip.pay!
          proc do
            delete_with @me, :destroy, id:@my_tip.id
            Tip.find(@my_tip.id).should_not be_nil
          end.should_not change(Tip, :count)
        end

        it '403 a :kinged tip' do
          mock_order
          proc do
            order = @me.current_order
            @me.current_order.rotate!
            order.reload
            order.charge!
            @my_tip.reload
            @my_tip.check_id = 1
            @my_tip.claim!
            @my_tip.kinged?.should be_true
            delete_with @me, :destroy, id:@my_tip.id
            Tip.find(@my_tip.id).should_not be_nil
          end.should_not change(Tip, :count)
        end

        it '403 her tip' do
          her_setup
          proc do
            delete_with @me, :destroy, id:@her_tip1.id
            Tip.find(@her_tip1.id).should_not be_nil
          end.should_not change(Tip, :count)
        end
      end
    end
  end
end
