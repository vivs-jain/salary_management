class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions

  before_validation :normalize_name

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }

  private

  def normalize_name
    self.name = name.to_s.strip.downcase
  end
end
