class Mutation < ApplicationRecord
    belongs_to :related_mutation, class_name: 'Mutation', optional: true
    belongs_to :wallet

    def get_type
        if (amount < 0)
            if (related_mutation_id.nil?)
                return "Withdraw"
            end
            return "Transfer Out"
        else
            if (related_mutation_id.nil?)
                return "Deposit"
            end
            return "Transfer In"
        end
        return "Unknown"
    end
end
