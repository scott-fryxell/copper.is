require 'spec_helper'

describe Page do
  YAML.load(File.read(Rails.root+'./spec/models/page_spider.yml')).each do |node|
    ((node[1]['variations'] ||= []) << node.first).each do |url|
      describe url do
        before :all do
          DatabaseCleaner.clean
          with_resque do
            Page.spider url
          end
          page = Page.where('url = ?',Page.normalize(url)).first
          page.adopted?.should be_true
        end
        node[1]['channels'].each do |page|
          type, auth = page['type'],page['auth']
          it "Channel with type:#{type}" do
            Channel.where('type = ?', type).count.should eq(1)
          end
          if auth
            it "Identity with type:#{type}" do
              Identity.where('type = ?', type).count.should eq(1)
            end
          end
        end
        (node[1]['same_author'] || []).each do |url|
          it "finds the same author on #{url}" do
            pending
            with_resque do
              Page.spider(url)
            end
            @author.reload
            Page.where('url = ?',Page.normalize(url)).first.author.should eq(@author)
          end
        end
        it 'creates an author' do
          Author.count.should eq(1)
        end

      end
      describe 'confidence of channels' do
        it 'orders the channels by how confident we are about them'
        it 'only these channels are found'
      end
    end
  end
  
  describe 'spider_all_orphaned' do
    it 'spiders all orphaned pages' do
      pending 'slow and useless'
      DatabaseCleaner.clean
      Page.create!(url:'http://google.com')
      Page.create!(url:'http://wikipedia.org')
      with_resque do
        proc do
          Page.spider_all_orphaned
        end.should_not raise_error
      end
    end
  end
  
end
