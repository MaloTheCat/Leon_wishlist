class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :wishlists, dependent: :destroy

  validates :name, presence: true
  validates :invite_code, presence: true, uniqueness: true

  before_validation :generate_invite_code, on: :create

  private

  def generate_invite_code
    self.invite_code ||= SecureRandom.alphanumeric(8).upcase
  end
end
