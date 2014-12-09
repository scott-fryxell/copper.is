shared_examples_for "State::Ownable" do

  describe 'ownable' do

    context 'adopded' do

      subject {create!(:adopted)}

      it '#reject!' do

        subject.reject!
        expect(subject.new_record?).to be_falsey
        expect(subject.orphaned?).to be_truthy
        expect(Page).to have_queued(subject.id, :discover_author_from_url!).once
        expect(Page).to have_queue_size_of(1)

      end

      it '#adopt!' do

        subject.adopt!
        expect(subject.adopted?).to be_truthy
        expect(Page).to have_queued(subject.id, :learn).once
        expect(Page).to have_queue_size_of(1)

      end
    end

    context 'orphaned' do

      subject {build!(:orphaned)}

      before do
        expect(subject.orphaned?).to be_truthy
      end

      describe '#discover_author_from_url!' do

        it 'http://example.com/brokenbydawn' do
          subject.discover_author_from_url!
          expect(subject.adopted?).to be_truthy
          expect(subject.author).not_to be_nil
          expect(Author.count).to eq(1)
        end

      end

      it '#reject!' do
        subject.reject!
        expect(subject.fostered?).to be_truthy
        expect(Page).to have_queued(subject.id, :discover_author_from_page!).once
        expect(Page).to have_queue_size_of(1)
      end

      it '#adopt!'

    end

    context 'fostered' do
      subject {build!(:fostered)}

      it '#reject' do
        subject.reject!
        expect(subject.homeless?).to be_truthy

        expect(Page).to have_queued(subject.id, :spider_page_for_leads)
        expect(Page).to have_queue_size_of(1)
      end

      describe '#discover_author_from_page!' do


        context 'undiscoverable' do
          it 'Mechanize::ResponseCodeError'
          it 'Net::HTTP::Persistent::Error'
        end

      end

      describe '#discover_author_from_link_elements!' do
        context "/test" do
          it "author for <link rel=author >", :vcr do
            subject.url = "#{Copper::Application.config.hostname}/test"
          end

          it "author from a elements", :vcr do
            subject.url = "#{Copper::Application.config.hostname}/test"
          end
        end
      end
      describe '#discover_author_from_wordpress_blog!' do

        it "for www.missionmission.org", :vcr do
          subject.url = "http://www.missionmission.org/"
        end

      end

      it '#discover_author_from_a_elements!'

    end

    context 'homeless' do

      subject {build!(:homeless)}

      it '#reject' do
        subject.reject!
        expect(subject.dead?).to be_truthy
        expect(Page).to have_queued(subject.id, :refund_paid_tips!).once
        expect(Page).to have_queue_size_of(1)
      end

      it '#adopt'
    end

    context 'dead'

  end

end
