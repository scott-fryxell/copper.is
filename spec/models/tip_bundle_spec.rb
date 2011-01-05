require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TipBundle do
  fixtures :users, :roles_users, :tip_bundles, :tips

  describe "when creating a new tip bundle" do
    before(:each) do
      @bundle = TipBundle.new
      @bundle.fan = users(:developer)
    end

    it "should save correctly when all the required values are set" do
      @bundle.save.should be_true
    end

    it "should require an association with a fan (user)" do
      @bundle.fan = nil
      @bundle.save.should be_false
    end

    it "should default to active upon creation" do
      @bundle.is_active.should be_true
    end
  end

  it "should only be one active tip bundle per user" do
    TipBundle.create(:fan => users(:patron))
    TipBundle.new(:fan => users(:patron)).save.should be_false
  end

  it "should have a unique tip bundle for each user" do
    TipBundle.create(:fan => users(:administrator))
    TipBundle.new(:fan => users(:developer)).save.should be_true
  end

  it "should find all the associated tips for the bundle" do
    tip_bundles(:active_bundle).tips.should include(tips(:first))
    tip_bundles(:active_bundle).tips.should include(tips(:second))
    tip_bundles(:active_bundle).tips.should include(tips(:third))
    tip_bundles(:active_bundle).tips.should include(tips(:fourth))
    tip_bundles(:active_bundle).tips.should include(tips(:fifth))
    tip_bundles(:active_bundle).tips.should include(tips(:sixth))
    tip_bundles(:active_bundle).tips.should include(tips(:seventh))
    tip_bundles(:active_bundle).tips.should include(tips(:eigth))
  end

  describe "when working with users" do
    before(:each) do
      @bundle = tip_bundles(:active_bundle)
    end

    it "should determine the correct active tip bundle" do
      @bundle.should == users(:patron).active_tip_bundle
    end

    describe "when rotating tip bundles" do
      it "should close the old bundle without error" do
        lambda { users(:patron).rotate_tip_bundle! }.should_not raise_error
      end

      it "should produce a new tip bundle different from the old one" do
        users(:patron).rotate_tip_bundle!
        users(:patron).active_tip_bundle.should_not == @bundle
      end

      it "should produce a new empty tip bundle" do
        users(:patron).rotate_tip_bundle!
        users(:patron).active_tip_bundle.tips.size.should == 0
      end
    end
  end

  describe "when calculating where the money is for the bundle" do
    before(:each) do
      @bundle = TipBundle.new
      @bundle.fan = users(:developer)
      @bundle.save

      locator1 = Locator.parse('http://example.com')
      locator1.page = Page.new(:description => 'example page')
      @bundle.tips << Tip.new(:locator => locator1, :amount_in_cents => 25)

      locator2 = Locator.parse('http://beefdeed.com/chunder')
      locator2.page = Page.new(:description => 'CHUNDER POW')
      @bundle.tips << Tip.new(:locator => locator2, :amount_in_cents => 25)

      locator3 = Locator.parse('http://beefdeed.com/horde')
      locator3.page = Page.new(:description => 'ALL HAIL THE HORDE')
      @bundle.tips << Tip.new(:locator => locator3, :amount_in_cents => 25)

      @bundle.save
    end

    it "should have a way to total up the number of associated tips" do
      @bundle.tips.size.should == 3
    end

    it "should be able to determine the value of all the tips" do
      total = 0

      total = @bundle.tips.sum('amount_in_cents');

      total.should == 75
    end
  end
end
