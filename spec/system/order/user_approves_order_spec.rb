require 'rails_helper'

describe 'User approves an order' do
  it 'should see an alert when order has been canceled' do
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
    order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer, status: 'canceled')
    Proposal.create!(total_value: 60, expire_date: '2024-12-16', discount: 50, tax: 10, description: 'Oferta', payment_method: 'Crédito', order: order)

    #Act
    login_as(owner)
    visit order_path(order)

    #Assert
    expect(Order.first.status).to eq 'canceled'
    expect(page).to have_content('ATENÇÃO: Esse pedido foi cancelado!')
    expect(page).not_to have_content('Aceitar proposta')
    expect(page).not_to have_content('Recusar proposta')
    expect(page).not_to have_content('Aceitar pedido')
    expect(page).not_to have_content('Recusar pedido')
  end

  context 'as a customer' do
    it 'shouldnt be able to see the approve and refuse buttons' do
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
      order = Order.create!(desired_date: '2024-12-30', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 11, buffet: buffet, event: event, user: customer)

      #Act
      login_as(owner)
      order_path(order)

      #Assert
      expect(page).not_to have_link('Aprovar pedido')
      expect(page).not_to have_link('Recusar')
    end

    it 'should be able to see an order proposal information correctly' do
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

      #Assert
      expect(page).to have_content('Proposta do buffet')
      expect(page).to have_content('R$ 60')
      expect(page).to have_content('R$ 50')
      expect(page).to have_content('R$ 10')
      expect(page).to have_content('Oferta')
      expect(page).to have_content('Crédito')
      expect(page).to have_button('Aceitar proposta')
      expect(page).to have_button('Recusar proposta')
    end

    it 'can approve an proposal and confirm order successfully' do
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
      click_on 'Aceitar proposta'

      #Assert
      expect(page).to have_content('Você aceitou a proposta com sucesso! Tenha um bom evento!')
      expect(Order.first.status).to eq 'confirmed'
    end

    it 'shouldnt be able to accept a proposal after expire date' do
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
      travel 1.year do
        click_on 'Aceitar proposta'
      end

      #Assert
      expect(page).to have_content('O tempo limite para aceitar essa proposta expirou.')
      expect(Order.first.status).to eq 'canceled'
    end

    it 'should be redirected when trying to access the order proposal page' do
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
      order = Order.create!(desired_date: '2024-12-07', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: customer)

      #Act
      login_as(customer)
      visit new_order_proposal_path(order)

      #Assert
      expect(current_path).to eq root_path
      expect(page).to have_content('Você não tem acesso à essa página.')
    end
  end
end