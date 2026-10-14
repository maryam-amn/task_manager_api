class ChangeNametoUsernameForUserTable < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :name, :username
  end
end
