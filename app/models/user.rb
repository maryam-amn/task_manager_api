class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true, length: { minimum: 4 }
  validates :password, length: { minimum: 6 }, presence: true

  has_many :tasks, dependent: :destroy
  def self.ransackable_attributes(auth_object = nil)
    %w[id username email created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
