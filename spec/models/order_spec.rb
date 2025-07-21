require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      order = build(:order)
      expect(order).to be_valid
    end

    it 'is invalid without user_id' do
      order = build(:order, user_id: nil)
      expect(order).not_to be_valid
      expect(order.errors[:user_id]).to include("can't be blank")
    end

    it 'is invalid with user_id less than or equal to 0' do
      order = build(:order, user_id: 0)
      expect(order).not_to be_valid
      expect(order.errors[:user_id]).to include("must be greater than 0")
    end

    it 'is invalid without pickup_address' do
      order = build(:order, pickup_address: '')
      expect(order).not_to be_valid
      expect(order.errors[:pickup_address]).to include("can't be blank")
    end

    it 'is invalid without delivery_address' do
      order = build(:order, delivery_address: '')
      expect(order).not_to be_valid
      expect(order.errors[:delivery_address]).to include("can't be blank")
    end

    it 'is invalid without items_description' do
      order = build(:order, items_description: '')
      expect(order).not_to be_valid
      expect(order.errors[:items_description]).to include("can't be blank")
    end

    it 'is invalid without estimated_value' do
      order = build(:order, estimated_value: nil)
      expect(order).not_to be_valid
      expect(order.errors[:estimated_value]).to include("can't be blank")
    end

    it 'is invalid with estimated_value less than or equal to 0' do
      order = build(:order, estimated_value: 0)
      expect(order).not_to be_valid
      expect(order.errors[:estimated_value]).to include("must be greater than 0")
    end
  end

  describe 'callbacks' do
    it 'sets requested_at before validation on create' do
      order = build(:order, requested_at: nil)
      expect { order.valid? }.to change { order.requested_at }.from(nil)
    end

    it 'does not override requested_at if already set' do
      specific_time = 1.hour.ago
      order = build(:order, requested_at: specific_time)
      order.valid?
      # Usar be_within para comparar timestamps com tolerância de 1 segundo
      expect(order.requested_at).to be_within(1.second).of(specific_time)
    end
  end

  describe 'scopes' do
    let!(:user1_order1) { create(:order, user_id: 1, requested_at: 2.hours.ago) }
    let!(:user1_order2) { create(:order, user_id: 1, requested_at: 1.hour.ago) }
    let!(:user2_order) { create(:order, user_id: 2, requested_at: 30.minutes.ago) }

    describe '.by_user' do
      it 'returns orders for specific user' do
        user1_orders = Order.by_user(1)
        expect(user1_orders).to contain_exactly(user1_order1, user1_order2)
      end

      it 'returns empty collection for user with no orders' do
        user3_orders = Order.by_user(3)
        expect(user3_orders).to be_empty
      end
    end

    describe '.recent' do
      it 'returns orders ordered by requested_at desc' do
        recent_orders = Order.recent
        expect(recent_orders.first).to eq(user2_order)
        expect(recent_orders.last).to eq(user1_order1)
      end
    end

    it 'can chain scopes' do
      user1_recent = Order.by_user(1).recent
      expect(user1_recent.first).to eq(user1_order2)
      expect(user1_recent.last).to eq(user1_order1)
    end
  end
end
