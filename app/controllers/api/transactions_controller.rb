class Api::TransactionsController < ApplicationController
    def withdraw
        begin
            user = validate_user_token()
            addr = user.wallet.address
            amount = params[:amount].to_i

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
            user = validate_user_token()
            addr = user.wallet.address
            amount = params[:amount].to_i

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
            user = validate_user_token()
            src_addr = user.wallet.address
            dst_addr = params[:destination_address]
            amount = params[:amount].to_i

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
