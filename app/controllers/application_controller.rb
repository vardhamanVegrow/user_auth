class ApplicationController < ActionController::API
    before_action :authenticate_user!
    def verify_admin
        unless current_user.role == 'admin'
            render json: { status: 403, message: "Access forbidden: Admin only."}, status: :forbidden
        end
    end
    before_action :configure_permitted_parameters, if: :devise_controller?
    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
        devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
    end
    
  end
