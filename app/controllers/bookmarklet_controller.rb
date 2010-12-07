class BookmarkletController < ApplicationController

  def weave
    render :action => 'weave.js', :layout => false
  end
end