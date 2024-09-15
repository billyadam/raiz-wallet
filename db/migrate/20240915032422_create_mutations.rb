class CreateMutations < ActiveRecord::Migration[7.2]
  def change
    create_table :mutations, id: :bigserial do |t|
      t.references :wallet, null: false, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
