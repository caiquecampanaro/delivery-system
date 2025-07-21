class Order < ApplicationRecord
  # Ransack
  include Ransack::Adapters::ActiveRecord::Base
  
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
  
  # Método de busca combinada para user_id ou items_description
  def self.search_by_term(term)
    return all if term.blank?
    
    # Verifica se o termo é um número (possível user_id)
    if term.to_s.match?(/^\d+$/)
      # Busca por user_id exato OU descrição contendo o termo
      where(user_id: term).or(where("lower(items_description) LIKE ?", "%#{term.downcase}%"))
    else
      # Busca apenas por descrição contendo o termo
      where("lower(items_description) LIKE ?", "%#{term.downcase}%")
    end
  end

  private

  def set_requested_at
    self.requested_at ||= Time.current
  end
end
