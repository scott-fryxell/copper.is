require 'spec_helper'

describe ProviderablePagesJob do
  it 'queues a Page@find_identity_from_author_link! job' do
    page_id = FactoryGirl.create(:page, author_state:'providerable').id
    ProviderablePagesJob.perform
    Page.should have_queued(page_id, :discover_identity!)
  end
end
