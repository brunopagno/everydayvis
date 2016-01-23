require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Everydayvis
  class Application < Rails::Application

    config.web_console.whitelisted_ips = '10.0.2.2'
    
    config.generators.assets = false
    config.generators.helper = false
    config.generators.test_framework = false
    config.generators do |g|
      g.view_specs false
      g.helper_specs false
    end

    # config.i18n.available_locales         = %w(pt-BR)
    # config.i18n.default_locale            = :'pt-BR'
    # config.i18n.locale                    = :'pt-BR'
    config.time_zone                      = 'Brasilia'
    config.active_record.raise_in_transactional_callbacks = true
  end
end
