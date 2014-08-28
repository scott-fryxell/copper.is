module URL
  module Knowable
    extend ActiveSupport::Concern

    included do
      scope :stranger,          -> { where(identity_state:'stranger') }
      scope :wanted,            -> { where(identity_state:'wanted') }
      scope :known,             -> { where(identity_state:'known') }

      before_save do |owner|
        if owner.stranger?
          owner.user = nil
        end
      end

      state_machine :identity_state, initial: :stranger do

        event :publicize do
          transition :stranger => :wanted
        end

        event :join do
          transition any => :known
        end

        #end relationship with user
        event :forget do
          transition any => :stranger
        end

        state :stranger, :wanted do
          validate :validate_user_id_is_nil
        end

        state :wanted do
          def ask_author_to_join
            raise "this author has a user" if self.user_id
            unless self.message

              send_wanted_message
              self.message = Time.now
              save!
            end
          end
        end

        state :known do
          validates :user_id, presence:true

          def create_page_for_author
            unless page = Page.find_by(url:self.url)
              page = Page.create(url:self.url,title:self.username, author_state:'adopted')
            end
            page.author = self
            if self.user
              self.user.touch
            end
          end
        end

        after_transition any => :wanted do |author,transition|
          Resque.enqueue author.class, author.id, :ask_author_to_join
        end
        after_transition any => :known do |author,transition|
          Resque.enqueue author.class, author.id, :create_page_for_author
        end
      end

    end


    def try_to_make_wanted!
      self.publicize! if self.tips.charged.count > 0
    end


  end
end
