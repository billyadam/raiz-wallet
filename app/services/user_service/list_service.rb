class UserService::ListService
    def initialize()
    end

    def list
        ActiveRecord::Base.transaction do
            users = User.all
            return users.map do |user|
                {
                    name: user.name,
                    username: user.username,
                    wallet: {
                        address: user.wallet.address
                    }
                }
            end
        end
    end
end