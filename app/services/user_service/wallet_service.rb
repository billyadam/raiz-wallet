class UserService::WalletService
    def initialize(user)
        @user = user
    end

    def get_wallet
        ActiveRecord::Base.transaction do
            wallet = @user.wallet
            mutations = wallet.mutations
            puts mutations

            mut_details = mutations.map do |mut|
                {
                    time: mut.created_at,
                    type: get_type(mut),
                    amount: mut.amount
                }
            end

            return {
                address: wallet.address,
                balance: wallet.get_balance,
                mutations: mut_details
            }
        end
    end

    private 

    def get_type(mut)
        if (mut.amount < 0)
            if (mut.related_mutation_id.nil?)
                return "Withdraw"
            else
                return "Transfer Out"
            end
        else
            if (mut.related_mutation_id.nil?)
                return "Deposit"
            else
                return "Transfer In"
            end
        end
    end
end