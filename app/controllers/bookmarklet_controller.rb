class BookmarkletController < ApplicationController

  def instructions
  end

  def weave
    render :action => 'weave', :layout => false
  end
end