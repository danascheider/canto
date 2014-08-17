source 'https://rubygems.org'

# Require Sinatra and JSON for back-end
gem 'sinatra', '~> 1.4.5'
gem 'json',    '~> 1.8.1'

# Use Thin web server
gem 'thin', '~> 1.6.2'

# Use ActiveRecord and SQLite 3 to manage DB records
gem 'sinatra-activerecord', '~> 2.0.2'
gem 'activerecord',         '>= 4.1.3'
gem 'acts_as_list',         '~> 0.4.0'
gem 'ancestry',             '~> 2.1.0'
gem 'sqlite3',              '~> 1.3.9', :platform => :ruby
gem 'rake',                 '~> 10.3.2'

# Use Sinatra-Backbone for the RestAPI module to prepare for integration
# with Backbone.js front-end
gem 'sinatra-backbone', '~> 0.1.1', :require => 'sinatra/backbone'

# Use Cucumber, RSpec, Webmock for testing
# Coveralls and SimpleCov monitor test coverage
group :test do 
  gem 'simplecov',        '>= 0.8.2'
  gem 'coveralls',        '>= 0.7.0'
  gem 'json_spec',        '~> 1.1.2'
  gem 'cucumber-sinatra', '~> 0.5.0'
  gem 'cucumber',         '~> 1.3.16'
  gem 'rspec',            '~> 3.0.0'
  gem 'rack-test',        '~> 0.6.2', require: 'rack/test'
  gem 'factory_girl',     '~> 4.4.0'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'serverspec',       '~> 2.0.0.beta4'
end

# Use require_all to clean up requires
gem 'require_all', '~> 1.3.2'
