# Generated by cucumber-sinatra. (2014-06-27 15:36:37 -0700)

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', './canto.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'json_spec/cucumber'
require 'rack/test'

Capybara.app = Canto

class CantoWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
  include RSpec::Mocks
  include Rack::Test::Methods
  include JsonSpec

  def app
    Canto.new
  end

  def last_json
    page.source
  end
end

World do
  CantoWorld.new
end
