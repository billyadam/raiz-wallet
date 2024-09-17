require 'rails_helper'

RSpec.describe Api::TransactionsController, type: :controller do
	let(:auth_token) { 'xyz123zbc456tuxyz123zbc456tu' }
	let(:session) { double(Session) }
	let(:user) { double(:user) }
	let(:wallet) { double(:wallet) }
	let(:wallet_addr) { "sdjogfbsrjofgjosg" }

	before do
		request.headers['Authorization'] = "Bearer #{auth_token}"
	end

	describe '#withdraw' do
		let (:withdraw_amount) { 500 }
		let (:remaining_amount) { 400 }
		let (:params) { { amount: withdraw_amount } }

		let (:withdraw_service) { double(TransactionService::WithdrawService) }

		context 'when everything success' do
			let(:expected_result) { {
				"message" => I18n.t("success.withdraw"),
				"data" => {
					"withdrawal_amount" => withdraw_amount,
					"latest_balance" => remaining_amount
				}
			}}
			
			it 'return 200' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::WithdrawService).to receive(:new).with(wallet_addr, withdraw_amount).and_return(withdraw_service)
				allow(withdraw_service).to receive(:withdraw).and_return(remaining_amount)

				post :withdraw, params: params

				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq(expected_result)
			end
		end

		context 'when insufficient balance' do
			it 'return 422' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::WithdrawService).to receive(:new).with(wallet_addr, withdraw_amount).and_return(withdraw_service)
				allow(withdraw_service).to receive(:withdraw).and_raise(UnprocessableError, I18n.t('errors.insufficient_balance'))

				post :withdraw, params: params

				expect(response).to have_http_status(422)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.insufficient_balance'))
			end
		end

		context 'when wallet not found' do
			it 'return 404' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::WithdrawService).to receive(:new).with(wallet_addr, withdraw_amount).and_return(withdraw_service)
				allow(withdraw_service).to receive(:withdraw).and_raise(ActiveRecord::RecordNotFound, I18n.t('errors.wallet_not_found'))

				post :withdraw, params: params

				expect(response).to have_http_status(404)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.wallet_not_found'))
			end
		end

		context 'when service returns other error' do
			let(:other_error) { "other error" }
			it 'return 500' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::WithdrawService).to receive(:new).with(wallet_addr, withdraw_amount).and_return(withdraw_service)
				allow(withdraw_service).to receive(:withdraw).and_raise(StandardError, other_error)

				post :withdraw, params: params

				expect(response).to have_http_status(500)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(other_error)
			end
		end

		context 'when token invalid' do
			it 'return 401' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(nil)
			
				post :withdraw, params: params

				expect(response).to have_http_status(401)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.invalid_token'))
			end
		end
	end

	describe '#deposit' do
		let (:amount) { 500 }
		let (:params) { { amount: amount } }

		let (:deposit_service) { double(TransactionService::DepositService) }

		context 'when everything success' do
			let(:expected_result) { {
				"message" => I18n.t("success.deposit"),
				"data" => {
					"deposit_amount" => amount
				}
			}}
			
			it 'return 200' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::DepositService).to receive(:new).with(wallet_addr, amount).and_return(deposit_service)
				allow(deposit_service).to receive(:deposit)

				post :deposit, params: params

				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq(expected_result)
			end
		end

		context 'when wallet not found' do
			it 'return 404' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::DepositService).to receive(:new).with(wallet_addr, amount).and_return(deposit_service)
				allow(deposit_service).to receive(:deposit).and_raise(ActiveRecord::RecordNotFound, I18n.t('errors.wallet_not_found'))

				post :deposit, params: params

				expect(response).to have_http_status(404)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.wallet_not_found'))
			end
		end

		context 'when service returns other error' do
			let(:other_error) { "other error" }
			it 'return 500' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::DepositService).to receive(:new).with(wallet_addr, amount).and_return(deposit_service)
				allow(deposit_service).to receive(:deposit).and_raise(StandardError, other_error)

				post :deposit, params: params

				expect(response).to have_http_status(500)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(other_error)
			end
		end

		context 'when token invalid' do
			it 'return 401' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(nil)
			
				post :deposit, params: params

				expect(response).to have_http_status(401)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.invalid_token'))
			end
		end
	end

	describe '#transfer' do
		let (:amount) { 500 }
		let (:dest_address) { "aasdfasdgasd" }
		let (:params) { { amount: amount, destination_address: dest_address } }

		let (:transfer_service) { double(TransactionService::TransferService) }

		context 'when everything success' do
			let(:expected_result) { {
				"message" => I18n.t("success.transfer"),
				"data" => {
					"destination_address" => dest_address,
					"transfer_amount" => amount
				}
			}}
			
			it 'return 200' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::TransferService).to receive(:new).with(wallet_addr, dest_address, amount).and_return(transfer_service)
				allow(transfer_service).to receive(:transfer)

				post :transfer, params: params

				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq(expected_result)
			end
		end

		context 'when insufficient balance' do
			it 'return 422' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::TransferService).to receive(:new).with(wallet_addr, dest_address, amount).and_return(transfer_service)
				allow(transfer_service).to receive(:transfer).and_raise(UnprocessableError, I18n.t('errors.insufficient_balance'))

				post :transfer, params: params

				expect(response).to have_http_status(422)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.insufficient_balance'))
			end
		end

		context 'when source wallet not found' do
			it 'return 404' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::TransferService).to receive(:new).with(wallet_addr, dest_address, amount).and_return(transfer_service)
				allow(transfer_service).to receive(:transfer).and_raise(ActiveRecord::RecordNotFound, I18n.t('errors.src_wallet_not_found'))

				post :transfer, params: params

				expect(response).to have_http_status(404)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.src_wallet_not_found'))
			end
		end

		context 'when destination wallet not found' do
			it 'return 404' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::TransferService).to receive(:new).with(wallet_addr, dest_address, amount).and_return(transfer_service)
				allow(transfer_service).to receive(:transfer).and_raise(ActiveRecord::RecordNotFound, I18n.t('errors.dest_wallet_not_found'))

				post :transfer, params: params

				expect(response).to have_http_status(404)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.dest_wallet_not_found'))
			end
		end

		context 'when service returns other error' do
		let(:other_error) { "other error" }
			it 'return 500' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)
				allow(user).to receive(:wallet).and_return(wallet)
				allow(wallet).to receive(:address).and_return(wallet_addr)
				allow(TransactionService::TransferService).to receive(:new).with(wallet_addr, dest_address, amount).and_return(transfer_service)
				allow(transfer_service).to receive(:transfer).and_raise(StandardError, other_error)

				post :transfer, params: params

				expect(response).to have_http_status(500)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(other_error)
			end
		end

		context 'when token invalid' do
			it 'return 401' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(nil)
			
				post :transfer, params: params

				expect(response).to have_http_status(401)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.invalid_token'))
			end
		end
	end
end