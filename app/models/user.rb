class User < ApplicationRecord

  has_secure_password

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  before_validation :normalize_email

  validates :first_name, presence: true
  validates :last_name, presence: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password,
            length: { minimum: 8 },
            if: -> { password.present? }

  def has_permission?(module_name, action)
    roles
      .where(active: true)
      .joins(:permissions)
      .exists?(
        permissions: {
          module_name: module_name.to_s.strip.downcase,
          action: action.to_s.strip.downcase
        }
      )
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

end
