# class ApplicationController < ActionController::Base
#   # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
#   allow_browser versions: :modern
# end

class ApplicationController < ActionController::Base

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user!
    return if current_user&.active?

    reset_session

    render json: {
      error: "Authentication required"
    }, status: :unauthorized
  end

  def authorize_permission!(module_name, action)
    unless current_user&.has_permission?(module_name, action)
      render json: {
        error: "You are not authorized to perform this action"
      }, status: :forbidden
    end
  end

end