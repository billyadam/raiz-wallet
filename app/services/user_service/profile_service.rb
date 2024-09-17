class UserService::ProfileService
    def initialize(user)
        @user = user
    end

    def profile
        ActiveRecord::Base.transaction do
            return {
                name: @user.name,
                username: @user.username,
                wallet: {
                    address: @user.wallet.address,
                    balance: @user.wallet.get_balance
                }
            }
        end
    end
end