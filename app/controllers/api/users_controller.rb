class Api::UsersController < ApplicationController
    def login
        begin
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
end
