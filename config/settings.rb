require 'slogger'
require 'yaml'
require 'reactive_support/core_ext/hash'

require File.expand_path '../database_task_helper.rb', __FILE__
require File.expand_path '../../lib/helpers/authorization_helper.rb', __FILE__
require File.expand_path '../../lib/helpers/error_handling.rb', __FILE__
require File.expand_path '../../lib/helpers/general_helper_methods.rb', __FILE__
require File.expand_path '../../lib/helpers/log_helper.rb', __FILE__

Dir['./config/**/*.rb'].each {|f| require f }
Dir['./lib/*.rb'].each {|f| require f }

DB_YAML_FILE = ENV['DB_YAML_FILE'] || File.expand_path('../database.yml', __FILE__)
CONFIG_FILE = ENV['CONFIG_FILE'] || File.expand_path('../config.rb', __FILE__)

DB_CONFIG_INFO = DatabaseTaskHelper.get_yaml(DB_YAML_FILE)

class Canto < Sinatra::Base

  ENV['RACK_ENV'] = 'defaults'
  db_location = ENV['TRAVIS'] ? 'mysql2://travis@127.0.0.1:3306/test' : DatabaseTaskHelper.get_string(DB_CONFIG_INFO[ENV['RACK_ENV']], ENV['RACK_ENV'])

  set :app_file, CantoConfig.config_info[:app_file]
  set :root, File.dirname(app_file)
  set :database, db_location
  set :data, CantoConfig.config_info[:data] || ''

  # =======================================#
  # Rack::Cors manages cross-origin issues #
  # =======================================#

  use Rack::Cors do 
    allow do 
      origins 'null', /localhost(.*)/
      resource '/*', methods: [:get, :put, :post, :delete, :options], headers: :any
    end
  end

  # ===========================================#
  # Enable logging for database and web server #
  # ===========================================#

  enable :logging

  slogger = Slogger::Logger.new 'canto', :info, :local0
  use Slogger::Rack::RequestLogger, slogger

  db_loggers = CantoConfig.config_info[:db_loggers].map {|filename| Logger.new(File.expand_path(filename, __FILE__)) }
  db_loggers << Logger.new(STDOUT) if ENV['LOG'] === true
  DB = Sequel.connect(database, loggers: db_loggers)

  # ================================== #
  # Sequel settings and modifications  #
  # ================================== #

  Sequel::Model.plugin :timestamps
  Sequel::Model.plugin :validation_helpers

  class Sequel::Dataset
    def to_json
      all.to_json
    end
  end

  helpers Sinatra::AuthorizationHelper 
  helpers Sinatra::ErrorHandling
  helpers Sinatra::GeneralHelperMethods
  helpers Sinatra::LogHelper
end
