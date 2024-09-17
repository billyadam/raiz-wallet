require 'rails_helper'

RSpec.describe Mutation, type: :model do
    let(:related_addres) { "xxx123000"}
    
    describe '#get_type' do
        context "when deposit" do
            let(:mutation) { Mutation.new(amount: 400, related_mutation_id: nil ) }

            it 'return returns deposit' do
                res = mutation.get_type
                expect(res).to eq("Deposit")
            end
        end

        context "when withdraw" do
            let(:mutation) { Mutation.new(amount: -400, related_mutation_id: nil ) }

            it 'return returns withdraw' do
                res = mutation.get_type
                expect(res).to eq("Withdraw")
            end
        end

        context "when transfer in" do
            let(:mutation) { Mutation.new(amount: 400, related_mutation_id: related_addres ) }

            it 'return returns transfer in' do
                res = mutation.get_type
                expect(res).to eq("Transfer In")
            end
        end

        context "when transfer out" do
            let(:mutation) { Mutation.new(amount: -400, related_mutation_id: related_addres ) }

            it 'return returns transfer out' do
                res = mutation.get_type
                expect(res).to eq("Transfer Out")
            end
        end
    end
end
