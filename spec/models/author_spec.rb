describe Author, :type => :model do

  subject(:author) {create!(:author_phony)}
  subject(:known_author) {create!(:author_phony, identity_state: :known)}
  subject(:user) {create!(:user)}

  it '#create_page_for_author' do

    author.user = user
    author.join!

    expect(author.known?) == true
    expect(author.valid?) == true

    expect(Author).to have_queued(author.id, :create_page_for_author).once

  end

  it '#create_page_for_author' do

    known_author.create_page_for_author

    expect(Page.count) == 1
    expect(Page.first.author).not_to be_nil

  end

  it '#invite_to_service' do
    author.invite_to_service
  end

  describe '#authorzer_name' do

    context 'malformed url' do

      it 'should return nil' do
        expect(Author.authorizer_name('%#sk4666')).to be_nil
      end

    end

  end


end
