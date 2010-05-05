class PatronizeController < ApplicationController

  def dump
    logger.info { 'url being tipped: ' + params[:patronized] }
    respond_to do |format|
      format.js
    end
  end
end