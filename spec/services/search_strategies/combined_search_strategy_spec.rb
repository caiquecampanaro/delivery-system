require 'rails_helper'

RSpec.describe SearchStrategies::CombinedSearchStrategy, type: :service do
  let!(:user1_order) { create(:order, user_id: 1, items_description: "Pizza Margherita") }
  let!(:user2_order) { create(:order, user_id: 2, items_description: "Hambúrguer") }
  let!(:user123_order) { create(:order, user_id: 123, items_description: "Combo 123 - Pizza Especial") }
  let(:strategy) { described_class.new }

  describe '#search' do
    it 'returns all orders when term is blank' do
      result = strategy.search("")
      expect(result.count).to eq(3)
    end

    it 'finds orders by user_id when term is numeric' do
      result = strategy.search("1")
      expect(result).to include(user1_order)
      expect(result).not_to include(user2_order)
    end

    it 'finds orders by items_description when term is text' do
      result = strategy.search("Pizza")
      expect(result).to include(user1_order, user123_order)
      expect(result).not_to include(user2_order)
    end

    it 'finds both user_id and description matches with numeric term' do
      result = strategy.search("123")
      expect(result).to include(user123_order) # matches both user_id and description
      expect(result.count).to eq(1)
    end

    it 'is case-insensitive for description search' do
      result = strategy.search("pizza")
      expect(result).to include(user1_order, user123_order)
    end

    it 'returns no results for non-matching terms' do
      result = strategy.search("Sushi")
      expect(result.count).to eq(0)
    end
  end
end
