# Be sure to restart your server when you modify this file.
Copper::Application.config.session_store :cookie_store,
  :key => 'copper.session',
  :expire_after => 90.days
