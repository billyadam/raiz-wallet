require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
	let(:auth_token) { 'xyz123zbc456tuxyz123zbc456tu' }

	let (:username) { "johny" }
	let (:password) { "password" }
	let (:params) { { username: username, password: password } }

	let (:login_service) { double(UserService::LoginService) }

	describe '#login' do
		context 'when login success' do
			let(:expected_result) { {
				"message" => I18n.t("success.login"),
				"data" => {
					"token" => auth_token
				}
			}}
			
			it 'return 200' do
				allow(UserService::LoginService).to receive(:new).with(username, password).and_return(login_service)
				allow(login_service).to receive(:login).and_return(auth_token)

				post :login, params: params

				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq(expected_result)
			end
		end

		context 'when user not found' do
			it 'return 404' do
				allow(UserService::LoginService).to receive(:new).with(username, password).and_return(login_service)
				allow(login_service).to receive(:login).and_raise(ActiveRecord::RecordNotFound, I18n.t('errors.user_not_found'))

				post :login, params: params

				expect(response).to have_http_status(404)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.user_not_found'))
			end
		end

		context 'when invalid password' do
			it 'return 401' do
				allow(UserService::LoginService).to receive(:new).with(username, password).and_return(login_service)
				allow(login_service).to receive(:login).and_raise(UnauthorizedError, I18n.t('errors.invalid_password'))

				post :login, params: params

				expect(response).to have_http_status(401)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.invalid_password'))
			end
		end

		context 'when service returns other error' do
			let(:other_error) { "other error" }
			it 'return 500' do
				allow(UserService::LoginService).to receive(:new).with(username, password).and_return(login_service)
				allow(login_service).to receive(:login).and_raise(StandardError, other_error)

				post :login, params: params

				expect(response).to have_http_status(500)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(other_error)
			end
		end
	end
end