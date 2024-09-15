require 'rails_helper'

RSpec.describe Api::TransactionsController, type: :controller do
	describe '#withdraw' do
		let (:wallet_id) { "abcd" }
		let (:amount) { 500 }
		context 'when everything success' do
			let(:expected_result) { {
				"message" =>"Withdrawal successful",
				"data" => {
					"address" => wallet_id,
					"amount" => amount
				}
			}}
			
			it 'return 200' do
				allow_any_instance_of(WithdrawService).to receive(:withdraw)

				params = { address: wallet_id, amount: amount }
				post :withdraw, params: params

				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq(expected_result)
			end
		end

		context 'when insufficient balance success' do
			it 'return 422' do
				allow_any_instance_of(WithdrawService).to receive(:withdraw).and_raise(UnprocessableError, I18n.t('errors.insufficient_balance'))

				params = { address: wallet_id, amount: amount }
				post :withdraw, params: params

				expect(response).to have_http_status(422)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.insufficient_balance'))
			end
		end

		context 'when wallet not found' do
			it 'return 404' do
				allow_any_instance_of(WithdrawService).to receive(:withdraw).and_raise(ActiveRecord::RecordNotFound, I18n.t('errors.wallet_not_found'))

				params = { address: wallet_id, amount: amount }
				post :withdraw, params: params

				expect(response).to have_http_status(404)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.wallet_not_found'))
			end
		end
	end
end