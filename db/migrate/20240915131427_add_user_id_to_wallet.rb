class AddUserIdToWallet < ActiveRecord::Migration[7.2]
  def change
    add_reference :wallets, :user, foreign_key: true
  end
end
