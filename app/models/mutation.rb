class Mutation < ApplicationRecord
    belongs_to :related_mutation, class_name: 'Mutation', optional: true
    belongs_to :wallet
end
