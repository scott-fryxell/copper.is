# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dirtywhitecouch_com_session',
  :secret      => 'db02063d322260150cef05ba6c37aa20c3bb9e305965b903c23d6ddab07289ba54baad2e5920a8bcce4ef4470f4b5eff675ece3000855da63023520e591d3c53'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
