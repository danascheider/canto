require 'sinatra'
require 'sinatra/activerecord'
require 'acts_as_list'
require 'json'
require 'require_all'
require_all 'models'
require_all 'helpers'
require_all 'controllers'

class Canto < Sinatra::Application
  set :database_file, 'config/database.yml'
  set :data, ''

  before do 
    validate_params(params)
  end

  get '/users/:id/tasks' do |id|
    # FIX: This will need a more robust error-handling approach - TBD
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
      status(401) unless read_authorized?(id, request_body)
      User.find(id).tasks.to_json
    end
  end

  get '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) { get_task(id) }
  end

  put '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) { update_task(id, request_body); 200 }
  end

  delete '/tasks/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) { delete_task(id); 204 }
  end

  # USER ROUTES
  # ===========

  post '/users' do 
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
      if create_authorized?(body = request_body)
        User.create!(body)
        return body({ 'secret_key' => User.last.secret_key }.to_json) && 201
      end
      401
    end
  end

  get '/users' do 
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
      status(401) unless admin_approved?(request_body)
      content_type :json
      User.all.to_json
    end
  end

  get '/users/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordNotFound, 404) do 
      return User.find(id).to_json
    end
  end

  put '/users/:id' do |id|
    begin_and_rescue(ActiveRecord::RecordInvalid, 422) do 
      if update_authorized?(id, body = request_body)
        User.find(id).update!(body)
        return status(200)
      end
      401
    end
  end
end