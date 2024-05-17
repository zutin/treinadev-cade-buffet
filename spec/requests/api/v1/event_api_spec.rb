require 'rails_helper'

describe 'Event API' do
  context 'GET /api/v1/events/1' do
    it 'success when available' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                          email: 'user@test.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            valet_service: true, can_change_location: true, buffet: buffet)
      EventPrice.create!(base_price: 600, additional_person_price: 10, additional_hour_price: 10,
                        weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      
      #Act
      get "/api/v1/events/#{event.id}?date=2024-05-16&guests=10"

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response["available"]).to eq(true)
      expect(json_response["estimated_value"]).to eq(600)
    end

    it 'success when not available' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                          email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Test 2', social_security_number: CPF.generate, contact_number: '(12) 99205-1023',
                              email: 'user2@customer.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            valet_service: true, can_change_location: true, buffet: buffet)
      EventPrice.create!(base_price: 600, additional_person_price: 10, additional_hour_price: 10,
                        weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      Order.create!(desired_date: '2024-12-16', estimated_invitees: 20, observation: 'Pedido antigo',
                        desired_address: 'Rua dos Bobos, 0', buffet: buffet, event: event, user: customer)
      
      #Act
      get "/api/v1/events/#{event.id}?date=2024-12-16&guests=10"

      #Assert
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse(response.body)
      expect(json_response["available"]).to eq(false)
      expect(json_response["message"]).to eq('ERRO - Não disponível')
      expect(json_response).not_to include('estimated_value')
    end

    it 'failure when event is disabled' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432',
                          email: 'user@test.com', password: 'password', role: 'owner')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                              email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                              zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
      event = Event.create!(name: 'Evento', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            valet_service: true, can_change_location: true, buffet: buffet, is_enabled: false, deleted_at: DateTime.current)
      EventPrice.create!(base_price: 600, additional_person_price: 10, additional_hour_price: 10,
                        weekend_base_price: 20, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      
      #Act
      get "/api/v1/events/#{event.id}?date=2024-05-16&guests=10"

      #Assert
      expect(response.status).to eq 404
    end

    it 'failure if event not found' do
      #Arrange
      #Act
      get "/api/v1/events/666777888"

      #Assert
      expect(response.status).to eq 404
    end

    it 'failure to verify availability if missing params' do
      #Arrange
      #Act
      get "/api/v1/events/1?date=2024-05-16"

      #Assert
      expect(response.status).to eq 404
    end
  end
end