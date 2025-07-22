class Order < ApplicationRecord
  include Ransack::Adapters::ActiveRecord::Base
  
  validates :user_id, presence: true, numericality: { greater_than: 0 }
  validates :pickup_address, presence: true, length: { minimum: 1 }
  validates :delivery_address, presence: true, length: { minimum: 1 }
  validates :items_description, presence: true
  validates :estimated_value, presence: true, numericality: { greater_than: 0 }
  validates :requested_at, presence: true

  before_validation :set_requested_at, on: :create

  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :recent, -> { order(requested_at: :desc) }
  
  def self.search_by_term(term)
    return all if term.blank?
    
    if term.to_s.match?(/^\d+$/)
      where(user_id: term).or(where("lower(items_description) LIKE ?", "%#{term.downcase}%"))
    else
      where("lower(items_description) LIKE ?", "%#{term.downcase}%")
    end
  end

  private

  def set_requested_at
    self.requested_at ||= Time.current
  end
end
