module Sinatra
  module AuthorizationHelper

    # The ++admin_only!++ method checks to make sure the logged-in user (i.e., the
    # one whose token is in the ++Authorization++ header) is authorized as an admin.
    # The identity of the logged-in user is determined based on the username
    # included in the token provided in the header. If the request does not include 
    # an ++Authorization++ header, the token is invalid, or the user whose credentials 
    # are used is not an admin, ++admin_only!++ calls ++access_denied++, halting the
    # request and returning a ++401++ status code.

    def admin_only!
      return if authorized? && current_user.admin?
      access_denied
    end

    # The ++access_denied++ method halts the current request and returns a ++401++
    # status code, adding the ++WWW-Authenticate++ header to the response and a
    # text response body reading "Authorization Required\n".

    def access_denied
      headers('WWW-Authenticate' => 'Basic realm="Restricted Area"')
      halt 401, "Authorization Required\n"
    end

    # The ++authorized?++ method creates a new ++Rack::Auth::Basic::Request++ object
    # from the ++request.env++ hash. The ++#provided?++ and ++#basic?++ methods
    # called ensure the authorization header was required and that it is consistent
    # with the HTTP Basic authentication scheme. ++authorized?++ also verifies that
    # the header has included the correct password for the given username.

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)      
      @auth.provided? && @auth.basic? && valid_credentials?
    end

    # The ++authorized_for_resource++ method verifies that the logged-in user (i.e.,
    # the user whose credentials are included in the ++Authorization++ header) is 
    # allowed to access the resource being requested. It determines this as follows:
    # 
    #   I.  If the user is an admin, they are allowed access to all resources
    #   II. If the user is not an admin:
    #       1. Their ++id++ attribute has to match the given ++user_id++, ensuring
    #          they only have access to resources belonging or assigned to them
    #       2. They may not set the ++admin++ attribute on their own account.
    #
    # All requests by non-admins attempting to set the ++admin++ attribute on any
    # account will not be processed and a ++401++ status code will be returned with
    # a ++WWW-Authenticate++ header.
    #
    # FIX: Non-admins attempting to set the ++admin++ attribute should be blocked,
    #      because there is no way for them to update that attribute through the 
    #      GUI, so they are known to be tech-savvy and have gone to some trouble
    #      to do that.

    def authorized_for_resource?(user_id)
      (current_user.id == user_id && !setting_admin?) || current_user.admin?
    end

    def current_user
      User.find(username: @auth.credentials.first)
    end

    def login
      return current_user.to_json if authorized?
      access_denied
    end

    def protect(klass)
      return 404 unless (@resource = klass[@id])
      access_denied unless authorized? && authorized_for_resource?(@resource.owner_id)
    end

    def protect_collection(body)
      return 404 unless (owner = User[@id])
      allowed = body.select {|hash| Task[hash[:id]].try_rescue(:owner_id) === @id.to_i}
      access_denied unless authorized? && (body === allowed || current_user.admin?)
    end

    def protect_communal
      access_denied unless authorized?
    end

    def setting_admin?
      request_body.try(:respond_to?, :has_key?) && (request_body.try(:has_key?, :admin) || request_body.try(:has_key?, 'admin'))
    end

    def valid_credentials?
      begin
        @auth.credentials.last == User.find(username: @auth.credentials.first).password
      rescue NoMethodError
        false
      end
    end
  end
end