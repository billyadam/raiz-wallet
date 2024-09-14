class Api::UsersController < ApplicationController
    def login
        render json: {
            status: "OK Login"
        }
    end
end
