# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pin-user-auth_session',
  :secret      => 'aefd7498b22d0a2f101bd8a19a962e162719d5f84e25fdd93b0001c5b77e66f92f092f11e4df6c15c61eeb39da9aef0063fb5b5eda30439c84e51ac4d8238242'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
