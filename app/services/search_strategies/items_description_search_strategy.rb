# frozen_string_literal: true

module SearchStrategies
  class ItemsDescriptionSearchStrategy < BaseSearchStrategy
    def search(term)
      return scope if term.blank?
      
      scope.where("lower(items_description) LIKE ?", "%#{term.downcase}%")
    end
  end
end
