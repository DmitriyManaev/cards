require File.expand_path('../boot', __FILE__)

require 'rails/all'
Bundler.require(*Rails.groups)

module Flashcards
  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true
    config.i18n.default_locale = :ru
    config.i18n.available_locales = [:ru, :en]
  end
end
