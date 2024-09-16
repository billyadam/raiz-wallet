require 'rails_helper'

RSpec.describe UserService::LoginService, type: :service do
    describe "#login" do
        let(:username) { "bono" }
        let(:password_raw) { "bono123" }
        let(:password_hash) { BCrypt::Password.create(password_raw) }
        let(:token) { "abcdefg1234" }
        let(:user) { User.create!(name: "Bono", username: username, password: password_hash) }

        context "when success" do
            it "login successfully" do
                allow(User).to receive(:find_by).with(username: username).and_return(user)

                allow(Session).to receive(:login).with(user).and_return(token)

                login = UserService::LoginService.new(username, password_raw)
                res = login.login()
                expect(res).to eq(token)
            end
        end

        context "when user not found" do
            it "raises not Found error" do
                allow(User).to receive(:find_by).with(username: username).and_return(nil)

                login = UserService::LoginService.new(username, password_raw)
                expect{ login.login() }.to raise_error(ActiveRecord::RecordNotFound, I18n.t("errors.user_not_found"))
            end
        end

        context "when password invalid" do
            it "raises not Unauthenticated" do
                user = User.create!(name: "Bono", username: username, password: password_hash)
                allow(User).to receive(:find_by).with(username: username).and_return(user)

                login = UserService::LoginService.new(username, "invalidpass123")
                expect{ login.login() }.to raise_error(UnauthorizedError, I18n.t("errors.invalid_password"))
            end
        end

        context "when session login returns other error" do
            let(:other_err) { "other error" }
            it "login successfully" do
                allow(User).to receive(:find_by).with(username: username).and_return(user)

                allow(Session).to receive(:login).with(user).and_raise(other_err)

                login = UserService::LoginService.new(username, password_raw)
                expect{ login.login() }.to raise_error(StandardError, other_err)
            end
        end
    end
end
