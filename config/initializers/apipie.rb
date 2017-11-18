Apipie.configure do |config|
  config.app_name                = "CWRU HvZ API"
  config.api_base_url            = "/api/v1/"
  config.doc_base_url            = "/api"
  config.reload_controllers      = true
  config.app_info                = "CWRU HvZ api documentation\n"
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers", "api", "**","*.rb")
  config.api_routes              = Rails.application.routes
  config.default_locale          = 'en'
  config.use_cache               = true #Rails.env.production?
end
