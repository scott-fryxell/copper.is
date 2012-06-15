require 'spec_helper'

describe Page do
  YAML.load(File.read(Rails.root+'./spec/models/page_spider.yml')).each do |node|
    ((node[1]['variations'] ||= []) << node.first).each do |url|
      context url do
        before :all do
          DatabaseCleaner.clean
          with_resque do
            Page.spider url
          end
          page = Page.where('url = ?',Page.normalize(url)).first
          page.adopted?.should be_true
        end
        node[1]['pages'].each do |page|
          site, path = page['site'], (page['path'] || '')
          it "Page with site:#{site.inspect}, and path:#{path.inspect}" do
            selection = Page.where('site = ? and path = ?', site, path)
            selection.count.should eq(1)
          end
        end
        node[1]['channels'].each do |page|
          site,user,auth = page['site'],page['user'],page['auth']
          it "Channel with site:#{site.inspect}, and user:#{user.inspect}" do
            Channel.where('site = ? and user = ?', site, user).count.should eq(1)
          end
          if auth
            it "AuthSource with site:#{site.inspect}, and user:#{user.inspect}" do
              AuthSource.where('site = ? and user = ?', site, user).count.should eq(1)
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
