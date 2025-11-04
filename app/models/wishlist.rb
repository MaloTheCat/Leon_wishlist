class Wishlist < ApplicationRecord
  belongs_to :user
  belongs_to :family
  has_many :gifts, dependent: :destroy

  validates :title, presence: true
  validates :year, presence: true, numericality: { only_integer: true }
  validates :is_public, inclusion: { in: [true, false] }

  scope :public_lists, -> { where(is_public: true) }
  scope :for_year, ->(year) { where(year: year) }
end
