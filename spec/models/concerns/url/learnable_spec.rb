shared_examples_for "URL::Learnable" do
  it "learns everything" do
    page.url = "#{Copper::Application.config.hostname}/test"
    page.learn

    expect(page.title).to eq("copper-test page")
    expect(page.description).to eq("I'm round")
    expect(page.url).to eq("http://www.copper.is/test")
    expect(page.thumbnail_url).to eq("http://www.copper.is/logo.svg")
  end

  context "learn title" do
    it "by title tag"
    it "by og:title"
  end

  context "learn description"

  context "learn image"

  context "learn canonicle url"

end
