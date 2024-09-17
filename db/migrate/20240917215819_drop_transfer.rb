class DropTransfer < ActiveRecord::Migration[7.2]
  def change
    drop_table :transfers
  end
end
