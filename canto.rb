require 'sinatra'
require 'sinatra/activerecord'
require 'require_all'
require_all 'models'

class Canto < Sinatra::Application
end