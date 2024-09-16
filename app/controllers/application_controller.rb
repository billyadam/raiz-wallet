class ApplicationController < ActionController::API
    # require Rails.root.join('lib', 'errors', 'unprocessable_error')
    # require Rails.root.join('lib', 'errors', 'unauthorized_error')

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

    def return_unauthorized_response(message)
        render json: {
            message: message
        }, status: :unauthorized
    end

    def validate_user_token
        auth = request.headers['Authorization'].to_s.split(' ')
        if (auth.length != 2 || auth[0] != 'Bearer')
            raise UnauthorizedError, I18n.t('errors.invalid_token')
        end
        bearer_token = auth[1]
        session = Session.get_active_session(bearer_token)
        if session.nil?
            raise UnauthorizedError, I18n.t('errors.invalid_token')
        else
            return session.user
        end
    end

    def handle_exception(exception)
        case exception
        when UnauthorizedError
            return_unauthorized_response(exception.message)
        when ActiveRecord::RecordNotFound
            return_not_found_response(exception.message)
        when UnprocessableError
            return_unprocessable_response(exception.message)
        else
            return_error_response(exception.message)
        end
    end
end
