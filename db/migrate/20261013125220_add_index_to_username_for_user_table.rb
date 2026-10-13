class AddIndexToUsernameForUserTable < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :username, :string, default: nil
    add_index :users, :username, unique: true
  end
end
