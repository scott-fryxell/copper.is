require 'spec_helper'

describe Authors::Facebook do

  describe "Should find idetity's from facebook url's" do
    it "finds user on facebook.com" do
      Author.provider_from_url("http://www.facebook.com/scott.fryxell").should be_true
    end
    
    it "finds user on facebook.com via their photo" do
      Author.provider_from_url("https://www.facebook.com/photo.php?fbid=415648305162300&set=a.304808032912995.69593.286232048103927&type=1&theater").should be_true
    end

    it "finds user on facebook.com via their photo, even if the photo is locked down" do
      Author.provider_from_url("https://www.facebook.com/photo.php?fbid=4198406752067&set=a.2719363096900.2127501.1041690079&type=1&theater").should be_true
    end
    
    it "finds user on facebook.com old style id" do
      Author.provider_from_url("https://www.facebook.com/profile.php?id=1340075098").should be_true
    end

  end

  describe "Should return nil for url's that don't provide user information" do
    it "https://www.facebook.com/" do
      Author.provider_from_url("https://www.facebook.com/").should be_false
    end

    it "http://www.facebook.com/r.php" do
      Author.provider_from_url("http://www.facebook.com/r.php?next=https%253A%252F%252Fwww.facebook.com%252Fhome.php&locale=en_US").should be_false
    end

    it "https://www.facebook.com/login.php" do
      Author.provider_from_url("https://www.facebook.com/login.php?next=https%3A%2F%2Fwww.facebook.com%2Fhome.php").should be_false
    end

    it "http://www.facebook.com/mobile/" do
      Author.provider_from_url("http://www.facebook.com/mobile/?ref=pf").should be_false
    end

    it "http://www.facebook.com/find-friends" do
      Author.provider_from_url("http://www.facebook.com/find-friends?ref=pf").should be_false
    end

    it "http://www.facebook.com/badges/" do
      Author.provider_from_url("http://www.facebook.com/badges/?ref=pf").should be_false
    end

    it "http://www.facebook.com/directory/" do
      Author.provider_from_url("http://www.facebook.com/directory/people/").should be_false
    end

    it "http://www.facebook.com/appcenter/" do
      Author.provider_from_url("http://www.facebook.com/appcenter/category/games/?ref=pf").should be_false
    end
  end

  describe "Messaging creators" do
    it "has a method to send an email" #do
    #   @author.respond_to?(:send_email).should be_true
    # end
    
    it "should send a non copper user an email that they have royalties" # do
    #  Twitter.stub(:update).with("@#{@author.username} Somebody loves you. You have money waiting for you go to copper.is/p/7657658675 to see")
    #  @author.inform_non_user_of_promised_tips
    # end
    
    it "should not send a copper user an email that we're trying to get them to use the service" # do
    #  @author.user = FactoryGirl.create(:user)
    #   Twitter.should_not_receive(:update)
    #   @author.inform_non_user_of_promised_tips
    # end
  end

  describe '#populate_uid_and_username!' do
    before do
      @author = FactoryGirl.create(:authors_facebook, username:"mgarriss")
    end
    
    after do
      @author.save.should be_true
      @author.populate_uid_and_username!
      @author.username.should == 'mgarriss'
      @author.uid.should == '597463246'
    end
    
    it 'finds the uid if usenname is set' # do
     #      @author.uid = nil
     #      @author.username = 'mgarriss'
     #    end
    
    it 'finds the username if uid is set' # do
     #      @author.uid = '597463246'
     #      @author.username = nil
     #    end
  end
  
end
