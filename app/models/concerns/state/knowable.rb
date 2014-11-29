module State
  module Knowable

    extend ActiveSupport::Concern

    included do

      scope :stranger,          -> { where(identity_state:'stranger') }
      scope :wanted,            -> { where(identity_state:'wanted') }
      scope :known,             -> { where(identity_state:'known') }

      before_save do |author|
        if author.stranger?
          author.user = nil
        end
      end

      state_machine :identity_state, initial: :stranger do

        event :invite do
          transition :stranger => :wanted
        end

        event :join do
          transition any => :known
        end

        event :forget do
          transition any => :stranger
        end

        after_transition any => :wanted do |author,transition|
          Resque.enqueue Author, author.id, :ask_author_to_join
        end

        after_transition any => :known do |author,transition|
          Resque.enqueue Author, author.id, :create_page_for_author
        end

        state :stranger, :wanted do

          validate :validate_user_id_is_nil

          def try_to_make_wanted!
            self.invite! if self.tips.charged.count > 0
          end

        end

        state :wanted do

          def invite_to_service
            raise "not implemented in subclass" unless block_given?
            raise "this author has a user" if self.user_id
            yield
          end

        end

        state :known do

          validates :user_id, presence:true

          def create_page_for_author
            unless page = Page.find_by(url:url)
              page = Page.create(url:url,title:username, author_state:'adopted')
            end
            page.author = self

            page.save

            if self.user
              self.user.touch
            end
          end
        end

      end

    end

  end
end
