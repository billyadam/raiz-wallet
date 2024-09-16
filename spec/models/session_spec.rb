require 'rails_helper'

RSpec.describe Session, type: :model do
  describe "#login" do
    let(:token) { "sfdusjjosdfkl" }
    let(:user) { User.new(username: "jojo", name: "Jojo", password: BCrypt::Password.create("password")) }

    it "returns the token correctly" do
      expect(Session).to receive(:new).and_call_original
      expect(SecureRandom).to receive(:hex).with(20).and_return(token)
      allow_any_instance_of(Session).to receive(:save!).and_return(true)

      token_res = Session.login(user)
      expect(token_res).to eq(token)
    end
  end
end
