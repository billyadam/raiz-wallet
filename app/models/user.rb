class User < ApplicationRecord
    has_one :wallet

    def authenticate(password)
        BCrypt::Password.new(self.password) == password
    end
end
