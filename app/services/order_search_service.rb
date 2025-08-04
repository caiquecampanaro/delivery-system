class OrderSearchService
  STRATEGY_TYPES = {
    user_id: SearchStrategies::UserIdSearchStrategy,
    items_description: SearchStrategies::ItemsDescriptionSearchStrategy,
    combined: SearchStrategies::CombinedSearchStrategy
  }.freeze

  def initialize(strategy_type = :combined, scope = Order.all)
    @strategy = build_strategy(strategy_type, scope)
  end

  def search(term)
    @strategy.search(term)
  end

  def self.search_by_term(term, strategy_type: :combined, scope: Order.all)
    new(strategy_type, scope).search(term)
  end

  private

  def build_strategy(strategy_type, scope)
    strategy_class = STRATEGY_TYPES[strategy_type]
    raise ArgumentError, "Unknown strategy type: #{strategy_type}" unless strategy_class
    
    strategy_class.new(scope)
  end
end
