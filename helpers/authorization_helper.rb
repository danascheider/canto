class Sinatra::Application
  module AuthorizationHelper
    def validate_and_create_user(body)
      (valid_admin_creation?(body) || !body.has_key?(:admin)) ? User.create!(body) : nil
    end

    def validate_and_update_user(id, body)
      (valid_admin_creation?(body) || !body.has_key?(:admin)) ? User.find(id).update!(body) : nil
    end

    def valid_admin_creation?(body)
      body.has_key?(:admin) && body.has_key?(:secret_key) && User.is_admin_key?(body[:secret_key])
    end
  end

  helpers AuthorizationHelper
end