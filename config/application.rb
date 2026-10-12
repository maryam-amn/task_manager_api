require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaskManagerApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    # we use it overridden if params[:_method] is set. This is the middleware which supports the PUT and DELETE HTTP method types.
    config.middleware.use Rack::MethodOverride
    # we use it to do/display notices and alerts
    config.middleware.use ActionDispatch::Flash
    # we use it to be able to use cookies, to write (the data is sent in the HTTP response header) and read (the data is read from HTTP request header) the cookies
    config.middleware.use ActionDispatch::Cookies
    # we use it to encrypted the cookies with the secrey_key_base and it can't be altered or read by users
    config.middleware.use ActionDispatch::Session::CookieStore
  end
end
