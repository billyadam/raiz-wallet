class Session < ApplicationRecord
    belongs_to :user

    TOKEN_EXPIRY_TIME = 2.day

    def self.login(user)
        session = Session.new
        session.token = SecureRandom.hex(20)
        session.user = user
        session.expired_at = TOKEN_EXPIRY_TIME.from_now
        session.save!

        return session.token
    end

    def self.get_active_session(token)
        Session.where('token = ? AND expired_at > ?', token, Time.now).first
    end
end
