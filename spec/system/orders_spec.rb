require 'rails_helper'

RSpec.describe "Orders", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Order creation" do
    it "creates a new order with valid data" do
      visit new_order_path

      expect(page).to have_content("Criar Novo Pedido")

      fill_in "ID do Usuário", with: "123"
      fill_in "Endereço de Coleta", with: "Rua das Flores, 123 - Centro"
      fill_in "Endereço de Entrega", with: "Av. Principal, 456 - Bairro Novo"
      fill_in "Descrição dos Itens", with: "2x Pizza Margherita, 1x Refrigerante"
      fill_in "Valor Estimado (R$)", with: "45.90"

      click_button "Criar Pedido"

      expect(page).to have_content("Pedido criado com sucesso!")
      expect(page).to have_content("Pedidos de Entrega")
    end

    it "shows validation errors for invalid data" do
      visit new_order_path

      # Submit form without filling required fields
      click_button "Criar Pedido"

      expect(page).to have_content("Erro ao criar pedido:")
    end

    it "shows navigation links" do
      visit new_order_path

      expect(page).to have_link("Cancelar")
      expect(page).to have_link("Delivery System")
      expect(page).to have_link("Novo Pedido")
      expect(page).to have_link("Listar Pedidos")
    end
  end

  describe "Orders listing" do
    let!(:user1_order) { create(:order, user_id: 1, items_description: "Pizza Margherita") }
    let!(:user2_order) { create(:order, user_id: 2, items_description: "Hambúrguer") }

    it "displays all orders when no filter is applied" do
      visit orders_path

      expect(page).to have_content("Pedidos de Entrega")
      expect(page).to have_content("Pizza Margherita")
      expect(page).to have_content("Hambúrguer")
    end

    it "filters orders by user ID" do
      visit orders_path

      fill_in "search_term", with: "1"
      click_button "Buscar"

      expect(page).to have_content("Pizza Margherita")
      expect(page).not_to have_content("Hambúrguer")
      expect(page).to have_content("Resultados para: 1")
    end
    
    it "filters orders by items description" do
      visit orders_path
      
      fill_in "search_term", with: "Pizza"
      click_button "Buscar"
      
      expect(page).to have_content("Pizza Margherita")
      expect(page).not_to have_content("Hambúrguer")
      expect(page).to have_content("Resultados para: Pizza")
    end
    
    it "finds both numeric and text matches with the same term" do
      create(:order, user_id: 123, items_description: "Combo 123 - Pizza Especial")
      
      visit orders_path
      
      fill_in "search_term", with: "123"
      click_button "Buscar"
      
      expect(page).to have_content("Combo 123 - Pizza Especial")
      expect(page).to have_content("Usuário: 123")
      expect(page).to have_content("Resultados para: 123")
    end

    it "shows empty state when no orders found" do
      visit orders_path
      
      fill_in "search_term", with: "999"
      click_button "Buscar"

      expect(page).to have_content("Nenhum pedido encontrado")
      expect(page).to have_content("Resultados para: 999")
    end

    it "shows clear button to remove filters" do
      visit orders_path
      
      fill_in "search_term", with: "1"
      click_button "Buscar"
      
      # Verificar se o filtro foi aplicado
      expect(page).to have_content("Pizza Margherita")
      expect(page).not_to have_content("Hambúrguer")

      click_link "Limpar"

      # Verificar se voltou para a listagem completa
      expect(current_path).to eq(orders_path)
      expect(page).to have_content("Pizza Margherita")
      expect(page).to have_content("Hambúrguer")
    end

    it "displays order cards with correct information" do
      visit orders_path

      within(".card", text: "Pizza Margherita") do
        expect(page).to have_content("Usuário: #{user1_order.user_id}")
        expect(page).to have_content("R$ #{sprintf('%.2f', user1_order.estimated_value)}")
        expect(page).to have_link("Ver Detalhes")
      end
    end
  end

  describe "Order details" do
    let!(:order) { create(:order, 
      user_id: 123,
      pickup_address: "Rua das Flores, 123",
      delivery_address: "Av. Principal, 456",
      items_description: "2x Pizza Margherita",
      estimated_value: 45.90
    ) }

    it "displays complete order information" do
      visit order_path(order)

      expect(page).to have_content("Detalhes do Pedido ##{order.id}")
      expect(page).to have_content("123")
      expect(page).to have_content("Rua das Flores, 123")
      expect(page).to have_content("Av. Principal, 456")
      expect(page).to have_content("2x Pizza Margherita")
      expect(page).to have_content("R$ 45,90")
    end

    it "shows navigation links" do
      visit order_path(order)

      expect(page).to have_link("Voltar")
      expect(page).to have_link("Novo Pedido")
      expect(page).to have_link("Ver Todos os Pedidos")
      expect(page).to have_link("Pedidos do Usuário #{order.user_id}")
    end

    it "navigates back to orders list" do
      visit order_path(order)

      click_link "Voltar"

      expect(current_path).to eq(orders_path)
    end
  end

  describe "Navigation" do
    it "navigates between pages correctly" do
      visit root_path

      expect(page).to have_content("Pedidos de Entrega")

      click_link "nav-new-order"
      expect(current_path).to eq(new_order_path)

      click_link "Delivery System"
      expect(current_path).to eq(root_path)
    end
  end

  describe "Responsive design" do
    it "displays properly on different screen sizes" do
      # Criar pedidos para garantir que os cards sejam exibidos
      create(:order, user_id: 1, items_description: "Pizza Margherita")
      
      visit orders_path

      # Test that Bootstrap classes are present
      expect(page).to have_css(".container")
      expect(page).to have_css(".row")
      expect(page).to have_css(".col-md-6") # Classe usada nos cards de pedidos
      expect(page).to have_css(".col-lg-4") # Classe usada nos cards de pedidos
    end
  end
end
