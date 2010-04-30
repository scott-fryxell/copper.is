class PatronizeController < ApplicationController

  def dump
    # logger.info { 'url being tipped: ' + params[:patronized] }      
    logger.info { 'url being tipped: ' }
    request.body.lines.each do |line|
      logger.info { 'BLARGH: ' + line }
    end
  end

end