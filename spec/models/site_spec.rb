require 'spec_helper'

include Sites

describe Site, :broken do
  before :all do
    DatabaseCleaner.clean
  end
  
  describe Sites::Github do
    before :all do
      with_resque do
        @page = Page.create!(url:'http://github.com/mgarriss')
      end
    end
    
    it 'finds author channel' do
      @page.author.channels.map(&:class).should include(Channels::Github)
    end
  end
  
  describe Sites::Rubygems do
    before :all do
      with_resque do
        @page = Page.create!(url:'https://rubygems.org/profiles/40496')
      end
    end
    
    it 'finds author channel' do
      @page.author.channels.map(&:class).should include(Channels::Rubygems)
    end
  end
  
  describe Sites::Soundcloud do
    before :all do
      with_resque do
        @page = Page.create!(url:'http://soundcloud.com/zmokingz')
      end
    end
  end
end
