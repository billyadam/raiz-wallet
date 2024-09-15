class Api::TransactionsController < ApplicationController
    def withdraw
        begin
            user = validate_user_token()
            addr = user.wallet.address
            amount = params[:amount].to_i

            withdrawService = TransactionService::WithdrawService.new(addr, amount)
            withdrawService.withdraw()

            return_success_response(I18n.t("success.withdraw"), {
                address: addr,
                amount: amount,
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
            depositService.deposit()

            return_success_response(I18n.t("success.deposit"), {
                address: addr,
                amount: amount
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
            transferService.transfer()

            return_success_response(I18n.t("success.transfer"), {
                source_address: src_addr,
                destination_address: dst_addr,
                amount: amount
            })
        rescue => e
            handle_exception(e)
        end
    end
end
