require 'rails_helper'

describe 'User refuses a proposal' do
  context 'as a customer' do
    it 'can refuse an proposal and cancel order successfully' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer, status: 'accepted_by_owner')
      Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)

      #Act
      login_as(customer)
      visit order_path(order)
      click_on 'Recusar proposta'

      #Assert
      expect(page).to have_content('Você recusou a proposta com sucesso!')
      expect(Order.first.status).to eq 'canceled'
    end
  end

  context 'as a buffet owner' do
    it 'can refuse an order successfully' do
      #Arrange
      owner = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      visit order_path(order)
      click_on 'Recusar pedido'

      #Assert
      expect(page).to have_content('Você recusou o pedido com sucesso!')
      expect(Order.first.status).to eq 'canceled'
    end
  end
end