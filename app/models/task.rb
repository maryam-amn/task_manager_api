class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { minimum: 5 }

  enum :status, %w[ draft in_progress done archived ].index_by(&:itself), default: :draft, validate: true

  delegate :username, to: :user

  def self.ransackable_associations(auth_object = nil)
    %w[id user_id title description status created_at updated_at]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id user_id title description status created_at updated_at]
  end
end
