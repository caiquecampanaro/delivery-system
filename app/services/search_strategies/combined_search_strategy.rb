module SearchStrategies
  class CombinedSearchStrategy < BaseSearchStrategy
    def search(term)
      return scope if term.blank?
      
      if numeric_term?(term)
        scope.where(user_id: term.to_i)
             .or(scope.where("lower(items_description) LIKE ?", "%#{term.downcase}%"))
      else
        scope.where("lower(items_description) LIKE ?", "%#{term.downcase}%")
      end
    end

    private

    def numeric_term?(term)
      term.to_s.match?(/^\d+$/)
    end
  end
end
