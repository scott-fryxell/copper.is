class UsersController < ApplicationController
  filter_access_to :all
  filter_access_to :claim_facebook_pages, :require => :read

  def claim_facebook_pages
    if pages = params[:facebook_objects]

      facebook = Author.where(provider:"facebook", user_id:current_user.id).first
      graph = Koala::Facebook::API.new(facebook.token)

      puts "getting facebook pages owned by author #{current_user.name}"
      pages.each  do |id|
        puts id
        fb_page =  graph.get_object(id)
        another_me = Author.find_or_create_from_url(fb_page['link'])

        another_me.user = current_user
        another_me.join!
      end
    end
    render nothing:true, status:200
  end

end
