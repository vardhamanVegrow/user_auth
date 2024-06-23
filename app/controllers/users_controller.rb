class UsersController < ApplicationController
    before_action :authenticate_user!
    
    def verify_user
        render json: {
            status: {
                code: 200, 
                message: "User is authenticated"
            },
            data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
        }, status: :ok  
    end
end