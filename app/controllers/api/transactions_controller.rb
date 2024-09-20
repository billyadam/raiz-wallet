class Api::TransactionsController < ApplicationController
    def withdraw
        begin
            permitted = params.permit(:amount)
            raise ActionController::ParameterMissing.new("amount") unless permitted[:amount]

            user = validate_user_token()
            addr = user.wallet.address
            amount = permitted[:amount].to_i

            withdrawService = TransactionService::WithdrawService.new(addr, amount)
            latest_balance = withdrawService.withdraw()

            return_success_response(I18n.t("success.withdraw"), {
                withdrawal_amount: amount,
                latest_balance: latest_balance
            })
        rescue => e
            handle_exception(e)
        end
    end

    def deposit
        begin
            permitted = params.permit(:amount)
            raise ActionController::ParameterMissing.new("amount") unless permitted[:amount]

            user = validate_user_token()
            addr = user.wallet.address
            amount = permitted[:amount].to_i

            depositService = TransactionService::DepositService.new(addr, amount)
            latest_balance = depositService.deposit()

            return_success_response(I18n.t("success.deposit"), {
                deposit_amount: amount,
                latest_balance: latest_balance
            })
        rescue => e
            handle_exception(e)
        end
    end

    def transfer
        begin
            permitted = params.permit(:amount, :destination_address)
            raise ActionController::ParameterMissing.new("amount") unless permitted[:amount]
            raise ActionController::ParameterMissing.new("destination_address") unless permitted[:destination_address]

            user = validate_user_token()
            src_addr = user.wallet.address
            dst_addr = permitted[:destination_address]
            amount = permitted[:amount].to_i

            transferService = TransactionService::TransferService.new(src_addr, dst_addr, amount)
            latest_balance = transferService.transfer()

            return_success_response(I18n.t("success.transfer"), {
                destination_address: dst_addr,
                transfer_amount: amount,
                latest_balance: latest_balance
            })
        rescue => e
            handle_exception(e)
        end
    end
end
