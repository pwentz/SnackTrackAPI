module UserHelper
  def current_user
    @current_user ||= User.find_by(google_id: params['googleId'])
  end
end
