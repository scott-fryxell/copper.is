require 'spec_helper'

describe TipsController do
  describe 'as Admin' do
    before :each do
      admin_setup
      me_setup
    end

    describe 'index' do
      describe '/tips' do
        it 'assigns all tips' do
          her_setup
          get_with @admin, :index
          tips = assigns(:tips)
          tips.include?(@her_tip2).should be_true
          tips.include?(@her_tip1).should be_true
          tips.include?(@my_tip).should be_true
        end

        it 'assigns all promised tips' do pending
          create!(:tip_charged)
          promized = create!(:tip_promised)
          create!(:tip_kinged)
          get_with @admin, :index, state:'promised'
          tips = assigns(:tips)
          tips.includes?(promised)
          tips.size.should == 1
        end

        it 'assigns all charged tips' do pending
          charged = create!(:tip_charged)
          create!(:tip_promised)
          create!(:tip_kinged)
          get_with @admin, :index, state:'charged'

          tips = assigns(:tips)
          tips.includes?(charged)
          tips.size.should == 1
        end

        it 'assigns all kinged tips' do pending
          create!(:tip_promised)
          create!(:tip_charged)
          kinged = create!(:tip_kinged)
          get_with @admin, :index, state:'kinged'
          tips = assigns(:tips)
          tips.includes?(kinged)
          tips.size.should == 1
        end

      end
    end

    describe 'show' do
      describe '/tips/:id' do
        it 'should display a tip' do
          get_with @admin, :show, id:@my_tip.id
          assigns(:tip).should eq(@my_tip)
          response.should be_success
        end
      end
    end
  end
end
