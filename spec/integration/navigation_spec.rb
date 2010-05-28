describe "The standard Weave page" do
  it "should contain a logo"
  it "should contain a global nav section"
  it "should contain an account section"
  it "should contain a courtesy nav section"
  it "should contain a content area"
  
  describe "global navigation" do
    it "should link to the pages report"
    it "should link to the publishers report"
    it "should link to the blog"
    it "should link to the user's home page"
    it "should contain a contextual 'fun' widget"
  end

  describe "account section" do
    describe "when logged in"do
      it "should link to a tip page for a fan"
      it "should link to a logout page when the fan is logged in"
      it "should link to a fan home page"
      it "should link to a publisher home page for a publisher"
      it "should link to a administrators home page for an administrator"
    end
    describe "when not logged in"do
      it "should include a login or register widget when guest is unknown"
    end
  end

  describe "courtesy navigation" do
    it "should link to an about the service page"
    it "should link to a subscribe page"
    it "should link to a contact and support page"
    it "should link to terms and privacy page"
    it "should contain the last 3 blog entries"
  end
end