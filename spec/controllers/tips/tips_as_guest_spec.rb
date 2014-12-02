describe TipsController, :type => :controller do
  subject {create!(:tip)}

  describe 'as Guest' do

    describe 'new' do
      describe '/tips/new' do
        it 'should respond with 200' do
          get :new
          expect(response.status).to eq(200)
        end
      end
    end

    describe 'create' do
      describe 'POST /tips' do
        it 'should respond with 401' do
          expect do
            post :create
            expect(response.status).to eq(401)
          end.not_to change(Tip, :count)
        end
      end
    end

    describe 'update' do
      describe 'PUT /tips/:id' do
        it 'respond with not authorized' do
          put :update, id:subject.id, tip:{url:'laskdjf'}
          expect(response.status).to eq(401)
        end
      end
    end

    describe 'destroy' do
      describe 'DELETE /tips/:id' do
        it 'should respond with not authorized' do
          subject.valid?
          expect do
            delete :destroy, id:subject.id
            expect(response.status).to eq(401)
          end.not_to change(Tip,:count)
        end
      end
    end
  end
end
