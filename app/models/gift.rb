class Gift < ApplicationRecord
  belongs_to :wishlist
  belongs_to :reserved_by, class_name: 'User', foreign_key: 'reserved_by_id', optional: true

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def reserved?
    reserved_by_id.present?
  end
end
