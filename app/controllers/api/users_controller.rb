class Api::UsersController < ApplicationController
    def index
        begin
            user_list_service = UserService::ListService.new()
            user_list = user_list_service.list

            return_success_response(I18n.t("success.user_list"), user_list)
        rescue => e
            handle_exception(e)
        end
    end

    def login
        begin
            permitted = params.permit(:username, :password)
            raise ActionController::ParameterMissing.new("username") unless permitted[:username]
            raise ActionController::ParameterMissing.new("password") unless permitted[:password]

            username = params[:username]
            password = params[:password]

            loginService = UserService::LoginService.new(username, password)
            token = loginService.login()

            return_success_response(I18n.t("success.login"), {
                token: token
            })
        rescue => e
            handle_exception(e)
        end
    end

    def profile
        begin
            user = validate_user_token()

            profileService = UserService::ProfileService.new(user)
            profile = profileService.profile()

            return_success_response(I18n.t("success.profile"), profile)
        rescue => e
            handle_exception(e)
        end
    end

    def wallet 
        begin
            user = validate_user_token()

            wallet_service = UserService::WalletService.new(user)
            wallet_detail = wallet_service.get_wallet()

            return_success_response(I18n.t("success.wallet"), wallet_detail)
        rescue => e
            handle_exception(e)
        end
    end
end
