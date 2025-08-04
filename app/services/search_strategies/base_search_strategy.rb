module SearchStrategies
  class BaseSearchStrategy
    def initialize(scope = Order.all)
      @scope = scope
    end

    def search(term)
      raise NotImplementedError, "#{self.class} must implement #search method"
    end

    protected

    attr_reader :scope
  end
end
