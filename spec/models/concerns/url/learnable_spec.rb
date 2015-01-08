shared_examples_for "URL::Learnable" do
  it "learns everything" do
    subject.url = "#{Copper::Application.config.hostname}/test"
    subject.learn

    expect(subject.title).to eq("copper-test page")
    expect(subject.description).to eq("I'm round")
    expect(subject.url).to eq("http://www.copper.is/test")
    expect(subject.thumbnail_url).to eq("http://www.copper.is/logo.svg")
  end

  context "learn title" do
    it "by title tag"
    it "by og:title"
  end

  context "learn description"

  context "learn image"

  context "learn canonicle url"

end
