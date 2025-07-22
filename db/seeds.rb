Order.destroy_all

orders_data = [
  { user_id: 1, pickup_address: "Rua das Flores, 123", delivery_address: "Av. Central, 456", items_description: "2x Pizza Margherita", estimated_value: 50.0 },
  { user_id: 2, pickup_address: "Rua Azul, 10", delivery_address: "Rua Verde, 20", items_description: "1x Hambúrguer, 2x Suco", estimated_value: 35.5 },
  { user_id: 3, pickup_address: "Av. das Palmeiras, 100", delivery_address: "Praça da Sé, 200", items_description: "Combo Sushi", estimated_value: 120.0 },
  { user_id: 4, pickup_address: "Rua do Sol, 5", delivery_address: "Rua da Lua, 8", items_description: "1x Lasanha, 1x Vinho", estimated_value: 80.0 },
  { user_id: 5, pickup_address: "Rua das Acácias, 77", delivery_address: "Rua das Orquídeas, 99", items_description: "3x Salada Caesar", estimated_value: 60.0 },
  { user_id: 6, pickup_address: "Av. Brasil, 700", delivery_address: "Rua Chile, 800", items_description: "2x Pastel, 1x Caldo de Cana", estimated_value: 25.0 },
  { user_id: 7, pickup_address: "Rua A, 1", delivery_address: "Rua B, 2", items_description: "Pizza Portuguesa", estimated_value: 45.0 },
  { user_id: 8, pickup_address: "Rua das Laranjeiras, 15", delivery_address: "Rua das Mangueiras, 30", items_description: "Feijoada Completa", estimated_value: 90.0 },
  { user_id: 9, pickup_address: "Rua do Café, 1000", delivery_address: "Rua do Chá, 2000", items_description: "Café da Manhã", estimated_value: 22.0 }
]

orders_data.each do |attrs|
  Order.create!(attrs)
end

puts "Criados #{Order.count} pedidos de exemplo."
