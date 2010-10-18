# Be sure to restart your server when you modify this file.

Wieners::Application.config.session_store :cookie_store, :key => '_wieners_session', :expire_after => 1.year

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# Wieners::Application.config.session_store :active_record_store
