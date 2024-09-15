class Api::TransactionsController < ApplicationController
    def withdraw
        begin
            addr_params = params[:address]
            amount_params = params[:amount].to_i

            withdrawService = WithdrawService.new(addr_params, amount_params)
            withdrawService.withdraw()

            return_success_response( "Withdrawal successful", {
                address: addr_params,
                amount: amount_params
            })
        rescue ActiveRecord::RecordNotFound => e
            return_not_found_response(e.message)
        rescue UnprocessableError => e
            return_unprocessable_response(e.message)
        rescue => e
            return_error_response(e.message)
        end
    end

    def deposit
        begin
            addr_params = params[:address]
            amount_params = params[:amount].to_i

            depositService = DepositService.new(addr_params, amount_params)
            depositService.deposit()

            return_success_response("Deposit successful", {
                address: addr_params,
                amount: amount_params
            })
        rescue ActiveRecord::RecordNotFound => e
            return_not_found_response(e.message)
        rescue UnprocessableError => e
            return_unprocessable_response(e.message)
        rescue => e
            return_error_response(e.message)
        end
    end

    def transfer
        begin
            src_addr_params = params[:src_wallet_addr]
            dst_addr_params = params[:dst_wallet_addr]
            amount_params = params[:amount].to_i

            transferService = TransferService.new(src_addr_params, dst_addr_params, amount_params)
            transferService.transfer()

            return_success_response("Transfer successful", {
                source_address: src_addr_params,
                destination_address: dst_addr_params,
                amount: amount_params
            })
        rescue ActiveRecord::RecordNotFound => e
            return_not_found_response(e.message)
        rescue UnprocessableError => e
            return_unprocessable_response(e.message)
        rescue => e
            return_error_response(e.message)
        end
    end
end
