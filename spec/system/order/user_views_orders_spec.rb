require 'rails_helper'

describe 'User views their orders' do
  context 'as a guest' do
    it 'should be redirected if not signed in' do
      #Arrange
      #Act
      visit orders_path
      #Assert
      expect(page).to have_content('Para continuar, faça login ou registre-se.')
    end
  end

  context 'as a buffet owner' do
    it 'can access the orders page from the navigation bar' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
  
      #Act
      login_as(user)
      visit root_path

      within('div#hotbar') do
        click_on 'Pedidos'
      end

      #Assert
      expect(current_path).to eq orders_path
    end

    it 'can access the orders page from the user dropdown menu' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)
  
      #Act
      login_as(user)
      visit root_path

      within('div#user_dropdown') do
        click_on 'Pedidos'
      end

      #Assert
      expect(current_path).to eq orders_path
    end

    it 'should receive an alert when there are no orders found' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
      email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
      zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user)

      #Act
      login_as(user)
      visit orders_path

      #Assert
      expect(page).to have_content('Você não tem nenhum pedido registrado.')
    end

    it 'can see their orders and statuses successfully' do
      #Arrange
      user1 = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user1)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                          weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order1 = Order.create!(desired_date: '2024-05-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 15, buffet: buffet, event: event, user: user2)
      order2 = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 11, buffet: buffet, event: event, user: user2)

      #Act
      login_as(user1)
      visit orders_path

      #Assert
      expect(page).to have_link(order1.code, href: order_path(order1))
      expect(page).to have_content('2024-05-16')
      expect(page).to have_content('Aguardando avaliação do buffet')
      expect(page).to have_link(order2.code, href: order_path(order2))
      expect(page).to have_content('2024-07-08')
      expect(page).to have_content('Aguardando avaliação do buffet')
    end

    it 'should be able to see an order information by clicking its code' do
      #Arrange
      user1 = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user1)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
      weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      Order.create!(desired_date: '2024-05-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 15, buffet: buffet, event: event, user: user2)
      order = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 11, buffet: buffet, event: event, user: user2)

      #Act
      login_as(user1)
      visit orders_path
      click_on(order.code)

      #Assert
      expect(current_path).to eq order_path(order)
      expect(page).to have_content(order.code)
      expect(page).to have_content('2024-07-08')
      expect(page).to have_content('Rua dos Bobos, 0')
      expect(page).to have_content('Estimativa de convidados: 11')
      expect(page).to have_content('Nome fantasia')
      expect(page).to have_content('Festa de 21 anos')
      expect(page).to have_content('Pedido efetuado por: Customer User')
      expect(page).not_to have_content('ATENÇÃO: Existem outros pedidos para esse mesmo dia!')
    end

    it 'should receive an alert when there is another event order for the same day' do
      #Arrange
      owner = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      first_customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      second_customer = User.create!(username: 'customer2', full_name: 'Customer Two', social_security_number: CPF.generate, contact_number: '(12) 97676-7676', email: 'customer2@test2.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                              email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                              zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: false, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                          weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                          event: event)
      Order.create!(desired_date: '2024-05-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 15, buffet: buffet, event: event, user: first_customer)
      order = Order.create!(desired_date: '2024-05-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, buffet: buffet, event: event, user: second_customer)

      #Act
      login_as(owner)
      visit order_path(order)

      #Assert
      within("div#alert-event-date") do
        expect(page).to have_content('ATENÇÃO: Existem outros pedidos para esse mesmo dia!')
      end
    end
  end

  context 'as a customer' do
    it 'can access the orders page from the navigation bar' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'customer')
  
      #Act
      login_as(user)
      visit root_path

      within('div#hotbar') do
        click_on 'Meus Pedidos'
      end

      #Assert
      expect(current_path).to eq orders_path
    end

    it 'can access the orders page from the user dropdown menu' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'customer')
  
      #Act
      login_as(user)
      visit root_path

      within('div#user_dropdown') do
        click_on 'Meus Pedidos'
      end

      #Assert
      expect(current_path).to eq orders_path
    end

    it 'should receive an alert when there are no orders found' do
      #Arrange
      user = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'customer')

      #Act
      login_as(user)
      visit orders_path

      #Assert
      expect(page).to have_content('Você não tem nenhum pedido registrado.')
    end

    it 'can see their orders and statuses successfully' do
      #Arrange
      user1 = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user1)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                          weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order1 = Order.create!(desired_date: '2024-05-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 15, buffet: buffet, event: event, user: user2)
      order2 = Order.create!(desired_date: '2024-07-08', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 11, buffet: buffet, event: event, user: user2)
  
      #Act
      login_as(user2)
      visit orders_path

      #Assert
      expect(page).to have_link(order1.code, href: order_path(order1))
      expect(page).to have_content('2024-05-16')
      expect(page).to have_content('Aguardando avaliação do buffet')
      expect(page).to have_link(order2.code, href: order_path(order2))
      expect(page).to have_content('2024-07-08')
      expect(page).to have_content('Aguardando avaliação do buffet')
    end

    it 'should be able to see an order information by clicking its code' do
      #Arrange
      user1 = User.create!(username: 'usertest', full_name: 'Test User', social_security_number: CPF.generate, contact_number: '(11) 99876-5432', email: 'user@test.com', password: 'password', role: 'owner')
      user2 = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Nome fantasia', company_name: 'Razão social', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                            email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                            zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user1)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Super evento', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                          weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, event: event)
      order = Order.create!(desired_date: '2024-05-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 15, buffet: buffet, event: event, user: user2)
  
      #Act
      login_as(user2)
      visit orders_path
      click_on(order.code)

      #Assert
      expect(current_path).to eq order_path(order)
      expect(page).to have_content(order.code)
      expect(page).to have_content('2024-05-16')
      expect(page).to have_content('Rua dos Bobos, 0')
      expect(page).to have_content('Estimativa de convidados: 15')
      expect(page).to have_content('Nome fantasia')
      expect(page).to have_content('Festa de 21 anos')
      expect(page).not_to have_content('Pedido efetuado por: Customer User')
    end
  end
end