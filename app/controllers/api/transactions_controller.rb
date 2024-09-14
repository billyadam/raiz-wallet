class Api::TransactionsController < ApplicationController
    def withdraw
        render json: {
            status: "OK winthdraw"
        }
    end

    def deposit
        render json: {
            status: "OK depoit"
        }
    end

    def transfer
        render json: {
            status: "OK transfer"
        }
    end
end
