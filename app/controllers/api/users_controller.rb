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
end
