class HomeController < ApplicationController
  respond_to :html
  caches_action :index, :blog, :terms, :privacy, :button, :authors, :about, :contact
end