class AddIndexToUsernameForUserTable < ActiveRecord::Migration[8.1]
  def change
    change_column_default :users, :username, from: "", to: nil
    add_index :users, :username, unique: true
  end
end
