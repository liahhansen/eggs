# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eggs_session',
  :secret      => 'e7962f800d4598f72f4bb4f7db276b523943ff1bd55c10ecadad5f5efa95b8911ec8864d6112dd4a5ac9cfba8cd45bb28f3c1bb60b8341bfffef5131144c9527'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
