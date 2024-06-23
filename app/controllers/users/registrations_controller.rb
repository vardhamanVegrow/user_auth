# frozen_string_literal: true
class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json

  private

  def respond_with(current_user, _opts = {})
    
    if resource.persisted?
      render json: {
        status: {
          code: 200, 
          message: 'Signed up successfully.'
        },
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {
          code: 400, 
          message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  
  end

  def sign_up_params  
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
  
  def build_resource(hash ={})
    hash[:role] = 'member'
    super
  end

end

