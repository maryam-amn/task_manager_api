class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_enum :status, %w[ draft in_progress done archived ]

    create_table :tasks do |t|
      t.integer :user_id, references: :users, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.enum :status, enum_type: :status, default: 'draft'

      t.timestamps
    end
  end
end
