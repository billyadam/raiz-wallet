class CreateSessions < ActiveRecord::Migration[7.2]
  def change
    create_table :sessions, id: :bigserial do |t|
      t.string :token
      t.references :user, null: false, foreign_key: true
      t.datetime :expired_at
      t.timestamps
    end
  end
end