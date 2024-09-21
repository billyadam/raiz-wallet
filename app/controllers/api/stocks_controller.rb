class Api::StocksController < ApplicationController
    def price_all
        begin
            stock_data = Stock.price_all

            return_success_response(I18n.t("success.stock_price_all"), stock_data)
        rescue => e
            handle_exception(e)
        end
    end
end
