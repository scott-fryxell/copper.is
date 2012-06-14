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
        end
        node[1]['pages'].each do |page|
          site, path = page['site'], (page['path'] || '')
          it "Page with site:#{site.inspect}, and path:#{path.inspect}" do
            Page.where('site = ? and path = ?', site, path).count.should eq(1)
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
      end
    end
  end
end
