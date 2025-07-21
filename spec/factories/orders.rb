FactoryBot.define do
  factory :order do
    user_id { Faker::Number.between(from: 1, to: 1000) }
    pickup_address { Faker::Address.full_address }
    delivery_address { Faker::Address.full_address }
    items_description { Faker::Food.description }
    requested_at { Time.current }
    estimated_value { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
  end

  factory :invalid_order, class: 'Order' do
    user_id { nil }
    pickup_address { '' }
    delivery_address { '' }
    items_description { '' }
    estimated_value { 0 }
  end
end
