class UserService::LoginService
    def initialize(username, password)
        @username = username
        @password = password
    end

    def login
        ActiveRecord::Base.transaction do
            user = User.find_by(username: @username)
            if user.nil?
                raise ActiveRecord::RecordNotFound, I18n.t('errors.user_not_found')
            end
            if !user.authenticate(@password)
                raise UnauthorizedError, I18n.t('errors.invalid_password')
            end
            Session.login(user)
        end
    end
end