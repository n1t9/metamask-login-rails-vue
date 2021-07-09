class ApplicationController < ActionController::Base
  before_action :authenticate

  HMAC_SECRET = 'tDeQfH7Nunk4cYwJYV6XmW2NyYGpqz2u'.freeze

  def authenticate
    return unless session[:token]

    jwt = JWT.decode(
      session[:token],
      HMAC_SECRET,
      true,
      { algorithm: 'HS256' }
    )[0].symbolize_keys
    @current_user = User.find_by(jwt)
  end

  def babel
    @babel ||= BabelSchmoozer.new(__dir__)
  end
end
