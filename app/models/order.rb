class Order < ApplicationRecord
  # Validations
  validates :user_id, presence: true, numericality: { greater_than: 0 }
  validates :pickup_address, presence: true, length: { minimum: 1 }
  validates :delivery_address, presence: true, length: { minimum: 1 }
  validates :items_description, presence: true
  validates :estimated_value, presence: true, numericality: { greater_than: 0 }
  validates :requested_at, presence: true

  # Callbacks
  before_validation :set_requested_at, on: :create

  # Scopes
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :recent, -> { order(requested_at: :desc) }

  private

  def set_requested_at
    self.requested_at ||= Time.current
  end
end
