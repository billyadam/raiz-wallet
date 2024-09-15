class CreateTransfers < ActiveRecord::Migration[7.2]
  def change
    create_table :transfers, id: :bigserial do |t|
      t.references :src_wallet, null: false, foreign_key: { to_table: :wallets }
      t.references :dest_wallet, null: false, foreign_key: { to_table: :wallets }
      t.integer :amount
      
      t.timestamps
    end
  end
end
