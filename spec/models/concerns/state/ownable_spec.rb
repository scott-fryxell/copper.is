shared_examples_for "State::Ownable" do


  describe 'ownable' do

    describe '#adoption_rate' do
      subject {create!(:adopted)}

      it "/test", :vcr do
        subject.save!
        expect(Page.adoption_rate).to eq(100)
      end

    end

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
          it 'Mechanize::ResponseCodeError', :vcr do
            expect(subject.discover_author_from_page!)
            expect(subject.dead?).to be_truthy
            expect(subject.author).to be_nil
          end

          it 'Net::HTTP::Persistent::Error'

          it 'http://fasterlighterbetter.com/', :vcr do
            subject.url = 'http://fasterlighterbetter.com/'
            subject.discover_author_from_page!
            expect(subject.author).to be_nil
          end

        end

      end

      describe '#discover_author_from_link_elements!' do

        context "/test" do
          it "author for <link rel=author >", :vcr do
            page = subject.spider.get "#{Copper::Application.config.hostname}/test"
            subject.discover_author_from_link_elements! page
            expect(subject.author).to_not be_nil
          end
        end

      end

      describe '#discover_author_from_wordpress_blog!' do

        it "for www.missionmission.org", :vcr do
          page = subject.spider.get ('http://www.missionmission.org/')
          subject.discover_author_from_wordpress_blog! page
          expect(subject.author).to_not be_nil
        end

      end

      describe '#discover_author_from_a_elements!' do
        context '/test' do
          it "author from a elements", :vcr do
            page = subject.spider.get "#{Copper::Application.config.hostname}/test"

            subject.discover_author_from_a_elements! page
            expect(subject.author).to_not be_nil

          end
        end
      end

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
