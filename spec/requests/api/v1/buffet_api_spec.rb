require 'rails_helper'

describe 'Buffet API' do
  context 'GET /api/v1/buffets' do
    it 'success' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                          contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate,
                          contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      Buffet.create!(trading_name: 'Buffeteria', company_name: 'Buffet festas e cia', registration_number: CNPJ.generate, contact_number: '(11) 91234-5678',
                    email: 'email@buffeteria.com', address: 'Rua das festas, 22', district: 'Bairro Central', city: 'Rio de Janeiro', state: 'RJ',
                    zipcode: '11622091', description: 'Buffet pra festas e atrações', payment_methods: 'Pix', user: user2)
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                        weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer, status: 'confirmed')
      order2 = Order.create!(desired_date: '2024-12-29', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 25, buffet: buffet, event: event, user: customer, status: 'confirmed')
      Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)
      Review.create!(rating: 5, comment: 'Muito bom serviço!', order: order, reviewer: customer)
      Review.create!(rating: 0, comment: 'Serviço foi péssimo!', order: order2, reviewer: customer)

      #Act
      get '/api/v1/buffets'

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]['trading_name']).to eq 'Nome fantasia'
      expect(json_response[0]['contact_number']).to eq '(11) 99876-5432'
      expect(json_response[0]['average_rating']).to eq 2.5
      expect(json_response[1]['trading_name']).to eq 'Buffeteria'
      expect(json_response[1]['contact_number']).to eq '(11) 91234-5678'
      expect(json_response[1]['average_rating']).to eq 0.0
    end

    it 'returns only enabled buffets' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                          contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate,
                          contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
      Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user, is_enabled: false, deleted_at: DateTime.current)
      Buffet.create!(trading_name: 'Buffeteria', company_name: 'Buffet festas e cia', registration_number: CNPJ.generate, contact_number: '(11) 91234-5678',
                    email: 'email@buffeteria.com', address: 'Rua das festas, 22', district: 'Bairro Central', city: 'Rio de Janeiro', state: 'RJ',
                    zipcode: '11622091', description: 'Buffet pra festas e atrações', payment_methods: 'Pix', user: user2)

      #Act
      get '/api/v1/buffets'

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1
      expect(json_response[0]['trading_name']).to eq 'Buffeteria'
      expect(json_response[0]['contact_number']).to eq '(11) 91234-5678'
    end

    it 'success with search params' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                          contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate,
                          contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
      Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      Buffet.create!(trading_name: 'Buffeteria', company_name: 'Buffet festas e cia', registration_number: CNPJ.generate, contact_number: '(11) 91234-5678',
                    email: 'email@buffeteria.com', address: 'Rua das festas, 22', district: 'Bairro Central', city: 'Rio de Janeiro', state: 'RJ',
                    zipcode: '11622091', description: 'Buffet pra festas e atrações', payment_methods: 'Pix', user: user2)

      #Act
      get "/api/v1/buffets?name=Nome"

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1
      expect(json_response[0]['trading_name']).to eq 'Nome fantasia'
      expect(json_response[0]['contact_number']).to eq '(11) 99876-5432'
      expect(json_response).not_to include('Buffeteria')
    end

    it 'returns empty when there is no buffet registered' do
      #Arrange
      #Act
      get '/api/v1/buffets'
      
      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 0
    end
  end

  context 'GET /api/v1/buffets/1' do
    it 'success' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                          email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                          zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer, status: 'confirmed')
      Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)
      Review.create!(rating: 3, comment: 'Muito bom serviço!', order: order, reviewer: customer)
      
      #Act
      get "/api/v1/buffets/#{buffet.id}"

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response["trading_name"]).to eq('Nome fantasia')
      expect(json_response["contact_number"]).to eq('(11) 99876-5432')
      expect(json_response['average_rating']).to eq 3.0
      expect(json_response.keys).not_to include('company_name')
      expect(json_response.keys).not_to include('registration_number')
      expect(json_response.keys).not_to include('created_at')
      expect(json_response.keys).not_to include('updated_at')
    end

    it 'failure when buffet is disabled' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                          contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user, is_enabled: false, deleted_at: DateTime.current)

      #Act
      get '/api/v1/buffets/1'

      #Assert
      expect(response.status).to eq 404
    end

    it 'failure if buffet not found' do
      #Arrange
      #Act
      get "/api/v1/buffets/666777888"

      #Assert
      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/buffets/1/events' do
    it 'success' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                          contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      Event.create!(name: 'Evento 1', description: 'Primeiro evento', minimum_participants: 10, maximum_participants: 20,
                    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                    valet_service: true, can_change_location: true, buffet: buffet)
      Event.create!(name: 'Evento 2', description: 'Segundo evento', minimum_participants: 30, maximum_participants: 40,
                    default_duration: 240, menu: 'Macarrão, carne assada', alcoholic_drinks: true, decorations: false,
                    valet_service: false, can_change_location: false, buffet: buffet)
      #Act
      get "/api/v1/buffets/#{buffet.id}/events"
      
      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]['name']).to eq 'Evento 1'
      expect(json_response[0]['description']).to eq 'Primeiro evento'
      expect(json_response[1]['name']).to eq 'Evento 2'
      expect(json_response[1]['description']).to eq 'Segundo evento'
    end

    it 'returns only enabled events' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                          contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      Event.create!(name: 'Evento 1', description: 'Primeiro evento', minimum_participants: 10, maximum_participants: 20,
                    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                    valet_service: true, can_change_location: true, buffet: buffet, is_enabled: false, deleted_at: DateTime.current)
      Event.create!(name: 'Evento 2', description: 'Segundo evento', minimum_participants: 30, maximum_participants: 40,
                    default_duration: 240, menu: 'Macarrão, carne assada', alcoholic_drinks: true, decorations: false,
                    valet_service: false, can_change_location: false, buffet: buffet)
      #Act
      get "/api/v1/buffets/#{buffet.id}/events"
      
      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1
      expect(json_response[0]['name']).to eq 'Evento 2'
      expect(json_response[0]['description']).to eq 'Segundo evento'
    end

    it 'returns empty when there are no events registered' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate,
                          contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      #Act
      get "/api/v1/buffets/#{buffet.id}/events"
      
      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 0
    end

    it 'failure if buffet not found' do
      #Arrange
      #Act
      get "/api/v1/buffets/666777888/events"

      #Assert
      expect(response.status).to eq 404
    end
  end
end