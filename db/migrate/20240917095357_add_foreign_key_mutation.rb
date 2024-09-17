class AddForeignKeyMutation < ActiveRecord::Migration[7.2]
  def change
    add_reference :mutations, :related_mutation, foreign_key: { to_table: :mutations }, index: true
  end
end
