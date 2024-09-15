class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :bigserial do |t|
      t.string :name
      t.string :username
      t.string :password
      t.timestamps
    end
  end
end
