class Admin::LibrariansController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_admin

    def index
        librarians = User.where(role: 'librarian')
        if librarians.present?
            serialized_librarians = librarians.map { |librarian| UserSerializer.new(librarian).serializable_hash[:data][:attributes]}
            render json: {
                status: {
                    code: 200,    
                    message: "librarians fetched"
                },
                data: serialized_librarians
            }, status: :ok
        else
            render json: {
                status: {
                    code: 401,    
                    message: "No librarians found"
                }
            }, status: :not_found
        end
    end

    def create
        librarian = User.new(librarian_params)
        librarian.role = 'librarian'
        if librarian.save 
            render json: { 
                status: {
                    code: 200, 
                    message: "Librarian created successfully."
                }
            }
        else
            render json: { 
                status: {
                    code:422, 
                    message: librarian.errors.full_messages.to_sentence 
                }
            }
        end
    end

    def destroy
        librarian = User.find(params[:id])
        if librarian.role == 'librarian'
            if librarian.destroy
                render json: {
                    status: { 
                        code: 200, 
                        message: "Librarian deleted successfully."
                    }
                }
            else
                render json: { 
                    status: {
                        code: 422, 
                        message: "Failed to delete librarian."
                    }
                }
            end
        else
            render json: { 
                status: {
                    code: 422, 
                    message: "Failed to delete not a librarian"
                }
            }
        end
    end

    private

    def librarian_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end
    
    def verify_admin
        unless current_user.role == 'admin'
            render json: { 
                status: {
                    code: 403, 
                    message: "Access forbidden: Admin only."
                }
            }
        end
    end
end