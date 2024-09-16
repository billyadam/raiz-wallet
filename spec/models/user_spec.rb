require 'rails_helper'

RSpec.describe User, type: :model do
  let(:password) { BCrypt::Password.create("password123")}
  let(:user) { User.new(name: "Johnny", username: "johnny", password: password) }

  describe '#authenticate' do
    context 'when password is correct' do
      it 'return true' do
        expect(user.authenticate("password123")).to eq(true)
      end
    end

    context 'when password is incorrect' do
      it 'return false' do
        expect(user.authenticate("password")).to eq(false)
      end
    end
  end
end
