require File.expand_path('../boot', __FILE__)

module Eggs
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  
    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{RAILS_ROOT}/extras )
  
    # Specify gems that this application depends on and have them installed with rake gems:install
    # config.gem "bj"
    # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
    # config.gem "sqlite3-ruby", :lib => "sqlite3"
    # config.gem "aws-s3", :lib => "aws/s3"
  
    config.gem 'hoptoad_notifier'
    config.gem 'authlogic'
    config.gem "acl9", :source => "http://gemcutter.org", :lib => "acl9"
    config.gem "factory_girl", :source => "http://gemcutter.org"
    config.gem "fastercsv"
    config.gem "prawn"
    config.gem "liquid"
    config.gem "validates_email_format_of"
    config.gem "spreadsheet"
    #config.gem "spec"
    #config.gem 'email_spec', :lib => 'email_spec'
    config.gem 'money'
  
    
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  
    # Skip frameworks you're not going to use. To use Rails without a database,
    # you must remove the Active Record framework.
    # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  
    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = :product_observer, :order_observer
  
    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names.
    config.time_zone = 'Pacific Time (US & Canada)'
  
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de
  end
end
