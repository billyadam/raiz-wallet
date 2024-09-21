require 'rails_helper'

RSpec.describe Api::StocksController, type: :controller do
    let(:stock_data) {
        [
            {
                "identifier" => "NIFTY 50",
                "change" => 27.25,
                "dayHigh" => 25445.7,
                "dayLow" => 25336.2,
                "lastPrice" => 25383.75,
                "lastUpdateTime" => "16-Sep-2024 16:00:00",
                "meta" => {
                    "companyName" => nil,
                    "industry" => nil,
                    "isin" => nil
                },
                "open" => 25406.65,
                "pChange" => 0.11,
                "perChange30d" => 2.1,
                "perChange365d" => 29.85,
                "previousClose" => 25356.5,
                "symbol" => "NIFTY 50",
                "totalTradedValue" => 187049240982.16,
                "totalTradedVolume" => 168694880,
                "yearHigh" =>25445.7,
                "yearLow" => 18837.85
            },
            {
                "identifier" => "BAJFINANCEEQN",
                "change" => -256.5,
                "dayHigh" => 7680,
                "dayLow" => 7322,
                "lastPrice" => 7342,
                "lastUpdateTime" => "16-Sep-2024 15:59:47",
                "meta" => {
                    "companyName" => "Bajaj Finance Limited",
                    "industry" => "Non Banking Financial Company (NBFC)",
                    "isin" => "INE296A13011"
                },
                "open" => 7680,
                "pChange" => -3.38,
                "perChange30d" => 7.07,
                "perChange365d" => -1.65,
                "previousClose" => 7598.5,
                "symbol" => "BAJFINANCE",
                "totalTradedValue" => 19973322583.350002,
                "totalTradedVolume" => 2679555,
                "yearHigh" => 8192,
                "yearLow" => 6187.8
            }
        ]
    }

    let(:expected_result) { {
        "message" => I18n.t("success.stock_price_all"),
        "data" => stock_data
    }}

    context 'when the request is successful' do
        it 'return 200' do
            allow(Stock).to receive(:price_all).and_return(stock_data)

            post :price_all

            expect(response).to have_http_status(200)
            expect(JSON.parse(response.body)).to eq(expected_result)
        end
    end

    context 'when endpoint returns error' do
        let(:other_error) { "other error" }
        it 'return 500' do
            allow(Stock).to receive(:price_all).and_raise(StandardError.new(other_error))

            get :price_all

            expect(response).to have_http_status(500)
            json_body = JSON.parse(response.body)
            expect(json_body["message"]).to eq(other_error)
        end
    end
end