class HomeController < ApplicationController
  respond_to :html

  caches_page [:index, :blog, :terms, :privacy, :button, :authors]

end