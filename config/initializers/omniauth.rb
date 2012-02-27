
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :github, GITHUB_KEY, GITHUB_SECRET
  provider :twitter, TWITTER_KEY, TWITTER_SECRET
end
