require 'spec_helper'

describe SpiderablePagesJob do
  it 'queues a Page@find_identity_from_author_link! job' do
    page_id = FactoryGirl.create(:page, author_state:'spiderable').id
    SpiderablePagesJob.perform
    Page.should have_queued(page_id, :find_identity_from_author_link!)
  end
end
