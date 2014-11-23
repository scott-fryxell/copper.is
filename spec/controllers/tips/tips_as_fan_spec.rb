require 'spec_helper'

describe TipsController, :type => :controller do
  before :each do
    me_setup
  end

  describe 'as Fan' do

    describe 'new' do
      describe '/tips/new' do
        it 'renders a form to specify a url to tip' do
          get_with @me, :new
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'create' do
      describe 'POST /tips' do
        it 'creates a tip to given url with default amount' do
          post_with @me, :create, tip:{url:'http://fasterlighterbetter.com'}
          expect(Tip.first.page.url).to eq('http://fasterlighterbetter.com')
          expect(Tip.first.order.user_id).to eq(@me.id)
        end

        it 'creates a tip to given url with given amount' do
          post_with @me, :create, tip:{url:'http://fasterlighterbetter.com', amount_in_cents:100}
          expect(Tip.first.page.url).to eq('http://fasterlighterbetter.com')
          expect(Tip.first.amount_in_cents).to eq(100)
        end

        it 'requires a url' do
          post_with @me, :create, tip:{title:'asldkjf'}
          expect(response.status).to eq(400)
        end
      end
    end

    describe 'update' do
      describe 'update /tips/:id' do
        it 'update the amount of the tip' do
          put_with @me, :update, id:@my_tip.id, tip:{amount_in_cents:200}
          expect(response.status).to eq(200)
          @my_tip.reload
          expect(@my_tip.amount_in_cents).to eq(200)
        end

        it 'does not update a non-promised tip' do
          put_with @me, :update, id:@my_tip.id, tip:{amount_in_cents:200}
          @my_tip.reload
          expect(@my_tip.amount_in_cents).to eq(200)
        end

        it 'does not update another fan\'s tip' do
          her_setup
          put_with @me, :update, id:@her_tip2.id, tip:{amount_in_cents:200}
          @her_tip2.reload
          expect(@her_tip2.amount_in_cents).not_to eq(200)
          expect(response.status).to eq(403)
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /t/:id' do
        it 'destroys a promised tip' do
          expect do
            expect(@my_tip.promised?).to be_truthy
            expect(Tip.find(@my_tip.id)).not_to be_nil
            delete_with @me, :destroy, id:@my_tip.id
            # proc{Tip.find(@my_tip.id).should be_nil}.should raise_error(ActiveRecord::RecordNotFound)
          end.to change(Tip, :count)
        end

        it '403 a :charged tip' do
          me_setup
          @my_tip.pay!
          expect do
            delete_with @me, :destroy, id:@my_tip.id
            expect(Tip.find(@my_tip.id)).not_to be_nil
          end.not_to change(Tip, :count)
        end

        it '403 a :kinged tip' do
          mock_order
          expect do
            order = @me.current_order
            @me.current_order.rotate!
            order.reload
            order.charge!
            @my_tip.reload
            @my_tip.check_id = 1
            @my_tip.claim!
            expect(@my_tip.kinged?).to be_truthy
            delete_with @me, :destroy, id:@my_tip.id
            expect(Tip.find(@my_tip.id)).not_to be_nil
          end.not_to change(Tip, :count)
        end

        it '403 her tip' do
          her_setup
          expect do
            delete_with @me, :destroy, id:@her_tip1.id
            expect(Tip.find(@her_tip1.id)).not_to be_nil
          end.not_to change(Tip, :count)
        end
      end
    end
  end
end
