class User < ApplicationRecord
  has_secure_password

  belongs_to :family
  has_many :wishlists, dependent: :destroy
  has_many :reserved_gifts, class_name: 'Gift', foreign_key: 'reserved_by_id'

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: :password_digest_changed?

  def full_name
    "#{first_name} #{last_name}"
  end
end
