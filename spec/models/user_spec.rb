require 'spec_helper'

describe User, :type => :model do
  subject(:me){create!(:user_with_facebook_author)}
  let(:her){create!(:user)}

  before :each do
    mock_user
  end

  it "can be created with omniauth" do
    auth = OmniAuth.config.mock_auth[:facebook]
    User.create_with_omniauth auth
  end

  describe 'authors' do


    context 'starting out' do

      it 'there should be always one', :broken do
        expect(Author.count).to eq(1)
        expect(me.authors.count).to eq(1)
        author = me.authors.first
        her.authors << author
        expect { me.save! }.to raise_error
        expect { author.save! }.to raise_error
        expect(me.authors.count).to be > 0
        expect(her.authors.count).to be > 0
      end

      it 'tipped pages shoud be zero' do
        expect(me.tipped_pages).to be_empty
      end

      it 'average royaties should be zero' do
        expect(me.average_royalties_in_cents).to eq 0
      end

      it 'royalties shoud be zero' do
        expect(me.tipped_pages.count).to be_empty
      end

      it 'paid royaties should be zero' do
        expect(me.paid_royalties).to be_empty
      end

      it 'pending royaties should be zero' do
        expect(me.pending_royalties).to be_empty
      end

      it 'all royaties should be zero' do
        expect(me.royalties).to be_empty
      end
    end


    describe 'with some royalties' do
      context "pending" do
        it "should have some authored pages"
        it "should have some tipped pages"
        it "should have some pending royalties"
      end

      context "paid" do
        it "should have some authored pages"
        it "should have some tipped pages"
        it "should have some paid royalties"
      end

    end

  end

  describe 'email' do

    it 'should validate emails with a + sign' do
      me = create!(:user_with_email)
    end

  end

  describe "lists" do

    it "should know all the fans who have tipped" do
      expect(User).to respond_to(:tipped)
    end

    it "should know all the fans who have provided payment info" do
      expect(User).to respond_to(:payment_info)
    end

  end



end
