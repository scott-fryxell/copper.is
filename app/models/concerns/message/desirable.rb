module Message

  module Desirable

    module Twitter

      def invite_to_service

        send_tweet ("A fan of yours has tipped you! The link explains it all.
                    #{Copper::Application.config.hostname}/authors/#{self.id}/edit")
      end

    end

    module Phony

      def invite_to_service
        # puts "#{self.inspect} URL=#{Copper::Application.config.hostname}/i/#{self.id}"
      end

    end

    module Youtube

      def invite_to_service
        comment("A fan of yours has tipped you! The link explains it all. #{Copper::Application.config.hostname}/authors/#{self.id}").post
      end

    end

    module Facebook

      def invite_to_service
        # TODO: invite facebook user to the service
      end

    end

    module Google

      def invite_to_service
        # TODO: invite a google plus user to the service
      end

    end

    module Tumblr

      def invite_to_service
        # TODO: invite a tumblr user to the service
      end

    end

    module Github

      def invite_to_service
        # TODO: invite a github user to the service
      end

    end


    module Soundcloud

      def invite_to_service
        # TODO: invite a souncloud user to the service
      end

    end


    module Vimeo

      def invite_to_service
        # TODO: invite a vimeo user to the service
      end

    end

    module Flickr

      def invite_to_service
        # TODO: invite a vimeo user to the service
      end

    end

  end

end
