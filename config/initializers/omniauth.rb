Rails.application.config.middleware.use OmniAuth::Builder do
  # set these in your environment
  # for heroku:
  #   heroku config:add <VAR_NAME>=<VALUE>
  provider :foursquare, ENV['FOURSQUARE_CONSUMER_KEY'], ENV['FOURSQUARE_CONSUMER_SECRET']
end
