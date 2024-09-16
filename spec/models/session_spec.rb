require 'rails_helper'

RSpec.describe Session, type: :model do
	let(:token) { "xyzabc12345678" }
	let(:user) { User.new(username: "jojo", name: "Jojo", password: BCrypt::Password.create("password")) }
	
	describe ".login" do
		it "returns the token correctly" do
			expect(Session).to receive(:new).and_call_original
			expect(SecureRandom).to receive(:hex).with(20).and_return(token)
			allow_any_instance_of(Session).to receive(:save!).and_return(true)

			token_res = Session.login(user)
			expect(token_res).to eq(token)
		end
	end

	describe ".get_active_session" do
		let(:session) { Session.new(token: token, user: user, expired_at: 1.day.from_now) }

		it "returns the session correctly" do
			expect(Session).to receive(:where).with('token = ? AND expired_at > ?', token, anything).and_return([session])

			session_res = Session.get_active_session(token)
			expect(session_res).to eq(session)
		end
	end
end
