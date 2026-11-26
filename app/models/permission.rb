class Permission < ApplicationRecord
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions

  before_validation :normalize_fields

  validates :name, presence: true, uniqueness: true

  validates :module_name, presence: true

  validates :action,
            presence: true,
            uniqueness: { scope: :module_name }

  private

  def normalize_fields
    self.name = name.to_s.strip.downcase
    self.module_name = module_name.to_s.strip.downcase
    self.action = action.to_s.strip.downcase
  end

end