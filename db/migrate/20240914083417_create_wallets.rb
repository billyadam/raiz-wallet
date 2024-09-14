class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets, id: :bigserial do |t|
      t.string :address
      t.timestamps
    end
  end
end
