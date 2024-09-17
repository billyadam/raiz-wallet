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
                detail = {
                    time: mut.created_at,
                    type: mut.get_type,
                    amount: mut.amount
                }
                if detail[:type] == "Transfer In"
                    detail[:source_address] = mut.related_mutation.wallet.address
                end
                if detail[:type] == "Transfer Out"
                    detail[:destination_address] = mut.related_mutation.wallet.address
                end
                detail
            end

            return {
                address: wallet.address,
                balance: wallet.get_balance,
                mutations: mut_details
            }
        end
    end
end