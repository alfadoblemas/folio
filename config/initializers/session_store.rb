# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_factura_session',
  :secret      => '7ce2d21050ccb8b54c4f4572407fa6643015669668cd23c14139b6e4ea0adda4b68c6096eff5a9a5b895f9b359c72195187b5ef6b59a8f154cc7af3fb85aa358'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
