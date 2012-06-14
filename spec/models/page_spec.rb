require 'spec_helper'

describe Page do
  YAML.load(File.read(Rails.root+'./spec/models/page_spider.yml')).each do |node|
    ((node[1]['variations'] ||= []) << node.first).each do |var|
      context do
        before :all do
          DatabaseCleaner.clean
          with_resque do
            Page.spider var
          end
        end
        node[1]['pages'].each do |page|
          site,path = page['site'],page['path']
          it "Page with site:#{site}, and path:#{path} is created" do
            Page.where('site = ?', site).count.should eq(1)
          end
        end
        node[1]['channels'].each do |page|
          type,user,auth = page['type'],page['user'],page['auth']
          it "Channel with type:#{type}, and user:#{user} is created" do
            Channel.where('type = ? and user = ?', type, user).count.should eq(1)
          end
          if auth
            it "AuthSource with type:#{type}, and user:#{user} is created" do
              AuthSource.where('type = ? and user = ?', type, user).count.should eq(1)
            end
          end
        end
      end
    end
  end
end
