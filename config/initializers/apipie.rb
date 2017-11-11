Apipie.configure do |config|
  config.app_name                = "CWRU HvZ API"
  config.api_base_url            = "/api/v1/"
  config.doc_base_url            = "/doc"
  config.reload_controllers      = true
  config.app_info = "CWRU HvZ api documentation\n"
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
end
