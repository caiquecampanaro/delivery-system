module SearchStrategies
  class UserIdSearchStrategy < BaseSearchStrategy
    def search(term)
      return scope if term.blank?
      
      if numeric_term?(term)
        scope.where(user_id: term.to_i)
      else
        scope.none
      end
    end

    private

    def numeric_term?(term)
      term.to_s.match?(/^\d+$/)
    end
  end
end
