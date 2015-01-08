describe Authorizer::Google, :type => :model do

  subject(:author){create!(:author_google, username:"_ugly", uid:'666')}

  describe '#itentity_from_url' do

    context 'identifiable' do

      it "from a profile" do
        expect(Author.identity_from_url 'https://plus.google.com/u/0/110700893861235018134/posts?hl=en').to be_truthy
      end

    end

    context 'unidentifiable' do

      it "google.com" do
        expect(Author.identity_from_url("http://google.com/")).to be_nil
      end

      it "www.google.com" do
        expect(Author.identity_from_url("http://www.google.com/")).to be_nil
      end

      it "plus.google.com" do
        expect(Author.identity_from_url("http://plus.google.com/")).to be_nil
      end

    end

  end

  it '#url' do
    expect(author.url).to eq("https://plus.google.com/666")
  end

  it '#determine_image' do
    expect(author.determine_image).to eq("https://plus.google.com/s2/photos/profile/666")
  end

end
