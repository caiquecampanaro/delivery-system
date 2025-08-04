# 🚚 Delivery System

Sistema completo de pedidos de entrega desenvolvido em Ruby on Rails referência ao iFood. Este projeto implementa uma solução full-stack com backend API REST e frontend com templates ERB.

## 📋 Funcionalidades

### Backend (API REST)
- ✅ **Criação de Pedidos**: Endpoint para criar novos pedidos de entrega
- ✅ **Consulta de Pedidos**: Busca pedidos por ID do usuário
- ✅ **Validação de Dados**: Validações robustas para todos os campos obrigatórios
- ✅ **Tratamento de Erros**: Respostas adequadas para cenários de erro
- ✅ **Suporte JSON**: API REST completa com respostas em JSON

### Frontend (ERB Templates)
- ✅ **Interface Moderna**: UI responsiva com Bootstrap 5
- ✅ **Formulário de Criação**: Interface intuitiva para criar pedidos
- ✅ **Listagem de Pedidos**: Visualização em cards com busca avançada por usuário ou descrição dos itens
- ✅ **Detalhes do Pedido**: Página completa com informações detalhadas
- ✅ **Validação Frontend**: Validação em tempo real com feedback visual
- ✅ **Navegação Intuitiva**: Menu de navegação e breadcrumbs

### Testes
- ✅ **Testes Unitários**: RSpec para modelos e controladores
- ✅ **Testes de Integração**: Capybara para interface do usuário
- ✅ **Factory Bot**: Geração de dados de teste
- ✅ **Cobertura Completa**: Cenários de sucesso e erro

## 🛠️ Tecnologias Utilizadas

- **Ruby**: 3.3.1
- **Rails**: 8.0.2
- **Banco de Dados**: PostgreSQL
- **Frontend**: ERB Templates + Bootstrap 5
- **Testes**: RSpec + Capybara
- **Validação**: ActiveRecord Validations
- **Estilização**: Bootstrap Icons

## 📦 Estrutura do Projeto

```
delivery_system/
├── app/
│   ├── controllers/
│   │   └── orders_controller.rb     # Controller principal
│   ├── models/
│   │   └── order.rb                 # Modelo Order com validações
│   └── views/
│       ├── layouts/
│       │   └── application.html.erb # Layout principal
│       └── orders/
│           ├── index.html.erb       # Listagem de pedidos
│           ├── new.html.erb         # Formulário de criação
│           └── show.html.erb        # Detalhes do pedido
├── config/
│   └── routes.rb                    # Configuração de rotas
├── db/
│   └── migrate/                     # Migrações do banco
├── spec/
│   ├── factories/                   # Factory Bot factories
│   ├── models/                      # Testes de modelo
│   └── system/                      # Testes de sistema (Capybara)
└── PROJECT_CHECKLIST.md            # Lista de tarefas do projeto
```

## 🚀 Como Executar

### Pré-requisitos
- Ruby 3.3.1 ou superior
- Rails 8.0.2 ou superior
- Postgresql

### Instalação

1. **Clone o repositório**:
   ```bash
   git clone <repository-url>
   cd delivery_system
   ```

2. **Instale as dependências**:
   ```bash
   bundle install
   ```

3. **Configure o banco de dados**:
   ```bash
   rails db:migrate
   ```

4.1 **(Opcional) Popule o banco com exemplos**:
   ```bash
   rails db:seed
   ```

Isso irá criar 9 pedidos de exemplo para você testar a listagem, paginação e funcionalidades do sistema.

4.2 **Inicie o servidor**:
   ```bash
   rails server
   ```

5. **Acesse a aplicação**:
   Abra seu navegador em `http://localhost:3000`

## 🧪 Executando os Testes

### Todos os testes
```bash
bundle exec rspec
```

### Testes específicos
```bash
# Testes do modelo
bundle exec rspec spec/models/

# Testes do sistema (Capybara)
bundle exec rspec spec/system/

# Testes com formato detalhado
bundle exec rspec --format documentation
```

## 📊 Modelo de Dados

### Order (Pedido)
| Campo | Tipo | Descrição | Validações |
|-------|------|-----------|------------|
| `user_id` | Integer | ID do usuário | Obrigatório, > 0 |
| `pickup_address` | String | Endereço de coleta | Obrigatório, não vazio |
| `delivery_address` | String | Endereço de entrega | Obrigatório, não vazio |
| `items_description` | Text | Descrição dos itens | Obrigatório |
| `requested_at` | DateTime | Data/hora da solicitação | Preenchido automaticamente |
| `estimated_value` | Decimal | Valor estimado | Obrigatório, > 0 |

## 🌐 API Endpoints

### Rotas Web (HTML)
- `GET /` - Página inicial (lista de pedidos)
- `GET /orders` - Lista todos os pedidos
- `GET /orders?q[user_id_eq]=123` - Lista pedidos por ID do usuário
- `GET /orders?q[items_description_cont]=pizza` - Lista pedidos contendo "pizza" na descrição dos itens
- `GET /orders/new` - Formulário de novo pedido
- `POST /orders` - Cria novo pedido
- `GET /orders/:id` - Detalhes do pedido

### API REST (JSON)
- `GET /api/v1/orders` - Lista pedidos (JSON)
- `GET /api/v1/orders?user_id=123` - Pedidos por usuário (JSON)
- `POST /api/v1/orders` - Cria pedido (JSON)
- `GET /api/v1/orders/:id` - Detalhes do pedido (JSON)

### Exemplo de Requisição API

**Criar Pedido**:
```bash
curl -X POST http://localhost:3000/api/v1/orders \
  -H "Content-Type: application/json" \
  -d '{
    "order": {
      "user_id": 123,
      "pickup_address": "Rua das Flores, 123",
      "delivery_address": "Av. Principal, 456",
      "items_description": "2x Pizza Margherita",
      "estimated_value": 45.90
    }
  }'
```

**Buscar Pedidos**:
```bash
curl http://localhost:3000/api/v1/orders?user_id=123
```

## 🎨 Interface do Usuário

### Características da UI/UX
- **Design Responsivo**: Funciona em desktop, tablet e mobile
- **Bootstrap 5**: Interface moderna e consistente
- **Ícones Intuitivos**: Bootstrap Icons para melhor usabilidade
- **Feedback Visual**: Mensagens de sucesso e erro claras
- **Validação em Tempo Real**: Feedback imediato no formulário
- **Navegação Intuitiva**: Menu fixo e breadcrumbs

### Páginas Principais
1. **Lista de Pedidos**: Cards responsivos com busca avançada
2. **Criar Pedido**: Formulário com validação completa
3. **Detalhes**: Visualização completa do pedido

## 🔍 Filtro de Busca Inteligente (Strategy)

A busca de pedidos utiliza o padrão **Strategy** para oferecer flexibilidade e clareza. O usuário pode buscar por:

- **ID do Usuário**: Filtra pedidos pelo ID exato do usuário
- **Descrição dos Itens**: Busca pedidos que contenham determinado texto na descrição dos itens
- **Combinação**: Um único termo pode encontrar correspondências em ambos os campos

### Como Usar

1. Acesse a página de listagem de pedidos (`/orders`)
2. Utilize o campo de busca no topo da página
3. (Opcional) Escolha a estratégia de busca no dropdown: combinada, apenas por ID, ou apenas por descrição
4. Digite o termo desejado
5. Clique em "Buscar" para aplicar o filtro
6. Para limpar o filtro, clique em "Limpar"

### Implementação Técnica

O sistema utiliza o padrão Strategy para separar as regras de busca:

- **Combinada** (`combined`): Detecta se o termo é numérico (busca por ID) ou texto (busca por descrição)
- **ID do Usuário** (`user_id`): Busca apenas por ID numérico
- **Descrição dos Itens** (`items_description`): Busca apenas na descrição dos itens

Exemplo de URLs:
```
/orders?search_term=pizza                 # Busca combinada (padrão)
/orders?search_term=123&search_strategy=user_id           # Busca apenas por ID
/orders?search_term=pizza&search_strategy=items_description # Busca apenas por descrição
```

**Para desenvolvedores:**
Toda a lógica de busca está modularizada em `app/services/order_search_service.rb` e `app/services/search_strategies/`. Novas estratégias podem ser adicionadas facilmente seguindo esse padrão.

## 🔧 Configuração de Desenvolvimento

### Gems Principais
- `rails` - Framework principal
- `Postgresql` - Banco de dados
- `puma` - Servidor web
- `rspec-rails` - Framework de testes
- `capybara` - Testes de interface
- `factory_bot_rails` - Geração de dados de teste
- `faker` - Dados falsos para testes

### Estrutura de Testes
```
spec/
├── factories/
│   └── orders.rb           # Factory para Order
├── models/
│   └── order_spec.rb       # Testes do modelo Order
├── system/
│   └── orders_spec.rb      # Testes de interface
└── rails_helper.rb         # Configuração RSpec
```

*Sistema de Delivery - Teste Prático para Desenvolvedor*
