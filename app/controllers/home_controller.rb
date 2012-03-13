class HomeController < ApplicationController
  respond_to :html
  caches_action :index
  caches_action :blog
  caches_action :terms
  caches_action :privacy
  caches_action :button
  caches_action :authors
  caches_action :about
  caches_action :contact
end