require 'rails_helper'

RSpec.describe SearchStrategies::ItemsDescriptionSearchStrategy, type: :service do
  let!(:pizza_order) { create(:order, user_id: 1, items_description: "Pizza Margherita") }
  let!(:burger_order) { create(:order, user_id: 2, items_description: "Hambúrguer") }
  let!(:combo_order) { create(:order, user_id: 3, items_description: "Combo 123 - Pizza Especial") }
  let(:strategy) { described_class.new }

  describe '#search' do
    it 'returns all orders when term is blank' do
      result = strategy.search("")
      expect(result.count).to eq(3)
    end

    it 'finds orders by items description (case-insensitive)' do
      result = strategy.search("pizza")
      expect(result).to include(pizza_order, combo_order)
      expect(result).not_to include(burger_order)
    end

    it 'finds orders by partial description match' do
      result = strategy.search("Hambúr")
      expect(result).to include(burger_order)
      expect(result).not_to include(pizza_order, combo_order)
    end

    it 'finds orders by numeric terms in description' do
      result = strategy.search("123")
      expect(result).to include(combo_order)
      expect(result).not_to include(pizza_order, burger_order)
    end

    it 'returns no results for non-matching terms' do
      result = strategy.search("Sushi")
      expect(result.count).to eq(0)
    end
  end
end
