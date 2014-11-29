describe TipsController, :type => :controller do
  let(:me) {create!(:user_can_give)}
  let(:page) {create!(:adopted_page)}
  let(:her) {create!(:user_can_give)}
  let(:kinged_tip) {create!(:tip_kinged)}

  describe 'as Fan' do

    describe 'new' do
      describe '/tips/new' do
        it 'renders a form to specify a url to tip' do
          get_with me, :new
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'create' do
      describe 'POST /tips' do
        it 'creates a tip to given url with default amount' do
          post_with me, :create, tip:{url:'http://fasterlighterbetter.com'}
          expect(Tip.first.page.url).to eq('http://fasterlighterbetter.com')
          expect(Tip.first.order.user_id).to eq(me.id)
        end

        it 'creates a tip to given url with given amount' do
          post_with me, :create, tip:{url:'http://fasterlighterbetter.com', amount_in_cents:100}
          expect(Tip.first.page.url).to eq('http://fasterlighterbetter.com')
          expect(Tip.first.amount_in_cents).to eq(100)
        end

        it 'requires a url' do
          post_with me, :create, tip:{amount_in_cents:100}
          expect(response.status).to eq(400)
        end
      end
    end

    describe 'update' do
      describe 'PATCH /tips/:id' do
        it 'update the amount of the tip' do
          tip = me.tip(url:page.url)
          put_with me, :update, id:tip.id, tip:{amount_in_cents:200}
          expect(response.status).to eq(200)
          tip.reload
          expect(tip.amount_in_cents).to eq(200)
        end

        it 'does not update a non-promised tip' do
          tip = me.tip(url:page.url)
          put_with me, :update, id:tip.id, tip:{amount_in_cents:200}
          tip.reload
          expect(tip.amount_in_cents).to eq(200)
        end

        it 'does not update another fan\'s tip' do
          her_tip = her.tip(url:page.url)
          put_with me, :update, id:her_tip.id, tip:{amount_in_cents:200}
          her_tip.reload
          expect(her_tip.amount_in_cents).not_to eq(200)
          expect(response.status).to eq(403)
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /tips/:id' do
        it 'destroys a promised tip' do

          tip = me.tip(url:page.url)
          expect(tip.promised?).to be_truthy
          expect(Tip.find(tip.id)).not_to be_nil
          expect(Tip.count).to eq(1)
          delete_with me, :destroy, id:tip.id
          expect(Tip.count).to eq(0)

        end

        it '403 a :charged tip' do
          tip = me.tip(url:page.url)
          tip.pay!
          expect do
            delete_with me, :destroy, id:tip.id
            expect(Tip.find(tip.id)).not_to be_nil
          end.not_to change(Tip, :count)
        end

        it '403 a :kinged tip' do
          kinged_tip.reload
          expect(kinged_tip.kinged?).to be_truthy
          delete_with me, :destroy, id:kinged_tip.id
          expect(Tip.find(kinged_tip.id)).not_to be_nil
        end

        it '403 her tip' do
          her_tip = her.tip(url:page.url)
          expect do
            delete_with me, :destroy, id:her_tip.id
            expect(Tip.find(her_tip .id)).not_to be_nil
          end.not_to change(Tip, :count)
        end
      end
    end
  end
end
