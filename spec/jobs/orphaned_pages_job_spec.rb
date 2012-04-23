require 'spec_helper'

describe OrphanedPagesJob do
  it 'queues a Page@find_identity_from_author_link! job' do
    page_id = FactoryGirl.create(:page, author_state:'orphaned').id
    OrphanedPagesJob.perform
    Page.should have_queued(page_id, :match_url_to_provider!)
  end
end
