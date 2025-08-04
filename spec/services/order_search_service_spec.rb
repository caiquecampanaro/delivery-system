require 'rails_helper'

RSpec.describe OrderSearchService, type: :service do  
  let!(:user1_order) { create(:order, user_id: 1, items_description: "Pizza Margherita") }
  let!(:user2_order) { create(:order, user_id: 2, items_description: "Hambúrguer") }
  let!(:user123_order) { create(:order, user_id: 123, items_description: "Combo 123 - Pizza Especial") }

  describe '.search_by_term' do
    context 'with combined strategy (default)' do
      it 'returns all orders when term is blank' do
        result = described_class.search_by_term("")
        expect(result.count).to eq(3)
      end

      it 'finds orders by user_id when term is numeric' do
        result = described_class.search_by_term("1")
        expect(result).to include(user1_order)
        expect(result).not_to include(user2_order)
      end

      it 'finds orders by items_description when term is text' do
        result = described_class.search_by_term("Pizza")
        expect(result).to include(user1_order, user123_order)
        expect(result).not_to include(user2_order)
      end

      it 'finds both numeric and text matches with numeric term' do
        result = described_class.search_by_term("123")
        expect(result).to include(user123_order) # matches both user_id and description
        expect(result.count).to eq(1)
      end
    end

    context 'with user_id strategy' do
      it 'finds orders only by user_id' do
        result = described_class.search_by_term("1", strategy_type: :user_id)
        expect(result).to include(user1_order)
        expect(result).not_to include(user2_order, user123_order)
      end

      it 'returns no results for text terms' do
        result = described_class.search_by_term("Pizza", strategy_type: :user_id)
        expect(result.count).to eq(0)
      end
    end

    context 'with items_description strategy' do
      it 'finds orders only by items description' do
        result = described_class.search_by_term("Pizza", strategy_type: :items_description)
        expect(result).to include(user1_order, user123_order)
        expect(result).not_to include(user2_order)
      end

      it 'finds orders by numeric terms in description' do
        result = described_class.search_by_term("123", strategy_type: :items_description)
        expect(result).to include(user123_order)
        expect(result.count).to eq(1)
      end
    end
  end

  describe '#initialize' do
    it 'raises error for unknown strategy type' do
      expect {
        described_class.new(:unknown_strategy)
      }.to raise_error(ArgumentError, "Unknown strategy type: unknown_strategy")
    end
  end

  describe '#search' do
    it 'delegates to the strategy' do
      service = described_class.new(:user_id)
      result = service.search("1")
      expect(result).to include(user1_order)
    end
  end
end
