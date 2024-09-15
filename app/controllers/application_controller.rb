class ApplicationController < ActionController::API
    require Rails.root.join('lib', 'errors', 'unprocessable_error')

    def return_not_found_response(message)
        render json: { 
            message:  
        }, status: :not_found
    end

    def return_error_response(message)
        render json: { 
            message: message 
        }, status: :internal_server_error
    end

    def return_unprocessable_response(message)
        render json: { 
            message: message 
        }, status: :unprocessable_entity
    end

    def return_success_response(message, data)
        render json: { 
            message: message,
            data: data 
        }
    end
end
