module UserHelper
  def current_user
    @current_user ||= User.find_by(google_id: session['google_id']) if session['google_id']
  end
end
