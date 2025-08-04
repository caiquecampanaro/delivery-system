require 'rails_helper'

RSpec.describe SearchStrategies::UserIdSearchStrategy, type: :service do
  let!(:user1_order) { create(:order, user_id: 1, items_description: "Pizza Margherita") }
  let!(:user2_order) { create(:order, user_id: 2, items_description: "Hambúrguer") }
  let(:strategy) { described_class.new }

  describe '#search' do
    it 'returns all orders when term is blank' do
      result = strategy.search("")
      expect(result.count).to eq(2)
    end

    it 'finds orders by numeric user_id' do
      result = strategy.search("1")
      expect(result).to include(user1_order)
      expect(result).not_to include(user2_order)
    end

    it 'returns no results for text terms' do
      result = strategy.search("Pizza")
      expect(result.count).to eq(0)
    end

    it 'returns no results for non-existent user_id' do
      result = strategy.search("999")
      expect(result.count).to eq(0)
    end
  end
end
