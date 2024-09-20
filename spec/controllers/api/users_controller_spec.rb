require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
	let(:auth_token) { 'xyz123zbc456tuxyz123zbc456tu' }

	describe '#index' do
		let(:user_list) {
			[
				{
					"name" => "Johny",
					"username" => "johny",
					"wallet" => {
						"address" => "xyzjohn1"
					}
				},
				{
					"name" => "Joko",
					"username" => "joko",
					"wallet" => {
						"address" => "xyzjoko2"
					}
				},
				{
					"name" => "Budi",
					"username" => "budi",
					"wallet" => {
						"address" => "xyzbudi3"
					}
				},
				{
					"name" => "Kaka",
					"username" => "kaka",
					"wallet" => {
						"address" => "xyzkaka4"
					}
				}
			]
		}

		let(:user_list_service) { double(UserService::ListService) }
		let(:expected_result) { {
			"message" => I18n.t("success.user_list"),
			"data" => user_list
		}}

		it 'return 200' do
			allow(UserService::ListService).to receive(:new).and_return(user_list_service)
			allow(user_list_service).to receive(:list).and_return(user_list)

			post :index

			expect(response).to have_http_status(200)
			expect(JSON.parse(response.body)).to eq(expected_result)
		end
	end

	describe '#login' do
		let (:username) { "johny" }
		let (:password) { "password" }
		let (:params) { { username: username, password: password } }

		let (:login_service) { double(UserService::LoginService) }
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

	describe '#profile' do
		before do
			request.headers['Authorization'] = "Bearer #{auth_token}"
		end

		let(:session) { double(Session) }

		let(:name) { "Joko" }
		let(:username) { "joko" }
		let(:address) { "sbgfjdbgkewkfkwp" }
		let(:balance) { 890 }

		let(:user) { User.new(name: name, username: username)}
		let(:wallet) { Wallet.new() }

		let(:profile) {
			{
                name: name,
                username: username,
                wallet: {
                    address: address,
                    balance: balance
                }
			}
		}
		let (:profile_service) { double(UserService::ProfileService) }

		context 'when return profile success' do
			let(:expected_result) { {
				"message" => I18n.t("success.profile"),
				"data" => {
					"name" => name,
					"username" => username,
					"wallet" => {
						"address" => address,
						"balance" => balance
					}
				}
			}}
			
			it 'return 200' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)

				allow(UserService::ProfileService).to receive(:new).with(user).and_return(profile_service)
				allow(profile_service).to receive(:profile).and_return(profile)

				get :profile

				expect(response).to have_http_status(200)
				expect(JSON.parse(response.body)).to eq(expected_result)
			end
		end

		context 'when invalid token' do
			it 'return 401' do
				allow(UserService::ProfileService).to receive(:new).with(user).and_return(profile_service)
				allow(profile_service).to receive(:profile).and_raise(UnauthorizedError, I18n.t('errors.invalid_token'))

				get :profile

				expect(response).to have_http_status(401)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(I18n.t('errors.invalid_token'))
			end
		end

		context 'when service returns other error' do
			let(:other_error) { "other error" }
			it 'return 500' do
				allow(Session).to receive(:get_active_session).with(auth_token).and_return(session)
				allow(session).to receive(:user).and_return(user)

				allow(UserService::ProfileService).to receive(:new).with(user).and_return(profile_service)
				allow(profile_service).to receive(:profile).and_raise(StandardError, other_error)

				get :profile

				expect(response).to have_http_status(500)
				json_body = JSON.parse(response.body)
				expect(json_body["message"]).to eq(other_error)
			end
		end
	end
end