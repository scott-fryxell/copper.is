describe Authorizer::Tumblr, :type => :model do

  describe '#identity_from_url' do

    context 'identifiable ' do

      it 'http://github.com/scott-fryxell/' do
        expect(Author.find_or_create_from_url('http://github.com/scott-fryxell/')).to be_truthy
      end

    end

    context 'unidentifiable' do

      it 'github.com' do
        expect(Author.identity_from_url('http://github.com/')).to be_nil
      end

      it 'www.github.com' do
        expect(Author.identity_from_url('http://www.github.com/')).to be_nil
      end

      it 'https://gist.github.com/1367918' do
        expect(Author.identity_from_url('https://gist.github.com/1367918')).to be_nil
      end

      it 'https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo' do
        expect(Author.identity_from_url('https://github.com/blog/1252-how-we-keep-github-fast?mkt_tok=3RkMMJWWfF9wsRoluqTIZKXonjHpfsX87essULHr08Yy0EZ5VunJEUWy2Yo')).to be_nil
      end

    end

  end

end
