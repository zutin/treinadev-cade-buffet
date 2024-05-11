require 'rails_helper'

describe 'User orders an event' do
  context 'as a guest' do
    it 'should be redirected if not signed in' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'customer')
      Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
      email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
      zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: user)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                    can_change_location: false, valet_service: true, buffet: user.buffet)

      #Act
      visit new_event_order_path(event)

      #Assert
      expect(page).to have_content('Para continuar, faça login ou registre-se.')
    end
  end

  context 'as a customer' do
    it 'can go to the order page from an event' do
      #Arrange
      owner = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                              email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                              zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: false, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                          weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                          event: event)

      #Act
      login_as(customer)
      visit root_path

      click_on 'Alegria para o mundo'
      within("div#event_#{event.id}_card") do
        click_on 'Contratar evento'
      end

      #Assert
      expect(current_path).to eq new_event_order_path(event)
      expect(page).to have_content('Estimativa de convidados')
      expect(page).to have_content('Data desejada')
      expect(page).not_to have_content('Endereço do evento')
      expect(page).to have_content('O endereço será o mesmo do buffet contratado.')
    end

    it 'can make an event order successfully' do
      #Arrange
      owner = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                              email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                              zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: true, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                          weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                          event: event)

      #Act
      login_as(customer)
      visit new_event_order_path(event)

      fill_in 'Estimativa de convidados', with: 10
      fill_in 'Data desejada', with: '2024-12-16'
      fill_in 'Endereço do evento', with: 'Rua das Flores, 0'

      click_on 'Salvar'

      #Assert
      expect(page).to have_content('Pedido efetuado com sucesso, o buffet te responderá em breve')
      within("div#order_#{Order.first.id}") do
        expect(page).to have_content("Pedido ##{Order.first.code}")
        expect(page).to have_content('16/12/2024')
        expect(page).to have_content('Aguardando avaliação do buffet')
      end
    end

    it 'should be redirected when event has no prices set' do
      #Arrange
      owner = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                              email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                              zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: false, valet_service: true, buffet: buffet)

      #Act
      login_as(customer)
      visit new_event_order_path(event)

      #Assert
      expect(current_path).to eq root_path
      expect(page).to have_content('Esse evento não tem preços definidos, portanto não pode ser contratado')
    end

    it 'shouldnt be able to make an order with missing information' do
      #Arrange
      owner = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'owner')
      customer = User.create!(username: 'customer', full_name: 'Customer User', social_security_number: CPF.generate, contact_number: '(11) 91234-6456', email: 'customer@test.com', password: 'password', role: 'customer')
      buffet = Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                              email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                              zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: owner)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                            default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                            can_change_location: false, valet_service: true, buffet: buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                          weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                          event: event)

      #Act
      login_as(customer)
      visit new_event_order_path(event)

      fill_in 'Estimativa de convidados', with: 10

      #Assert
      expect{click_on 'Salvar'}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'as a buffet owner' do
    it 'should be redirected when ordering as a buffet owner' do
      #Arrange
      user = User.create!(username: 'lucca', full_name: 'Gian Lucca', social_security_number: CPF.generate, contact_number: '(12) 98686-8686', email: 'gian@lucca.com', password: 'password', role: 'customer')
      Buffet.create!(trading_name: 'Alegria para o mundo', company_name: 'Razões muito especificas', registration_number: CNPJ.generate, contact_number: '(12) 91234-5678',
                    email: 'diversao@buffet2.com', address: 'Rua das Flores, 0', district: 'Morro da Alegria', city: 'Rio de Janeiro', state: 'RJ',
                    zipcode: '11644010', description: 'Buffet muito divertido e simpático', payment_methods: 'Dinheiro', user: user)
      user2 = User.create!(username: 'wladimir', full_name: 'Wladimir Souza', social_security_number: CPF.generate, contact_number: '(12) 97676-7676', email: 'wladimir@souza.com', password: 'password', role: 'owner')
      Buffet.create!(trading_name: 'Fantasias & CIA', company_name: 'Sem razão alguma', registration_number: CNPJ.generate, contact_number: '(11) 99876-5432',
                    email: 'buffet@contato.com', address: 'Rua dos Bobos, 0', district: 'Bairro da Igrejinha', city: 'São Paulo', state: 'SP',
                    zipcode: '09280080', description: 'Buffet para testes', payment_methods: 'Pix', user: user2)
      event = Event.create!(name: 'Festa de 21 anos', description: 'Esse evento cobre som, iluminação e bebidas', minimum_participants: 10, maximum_participants: 20,
                    default_duration: 120, menu: 'Arroz, feijão, batata', alcoholic_drinks: false, decorations: true,
                    can_change_location: false, valet_service: true, buffet: user.buffet)
      EventPrice.create!(base_price: 100, additional_person_price: 10, additional_hour_price: 10,
                        weekend_base_price: 200, weekend_additional_person_price: 20, weekend_additional_hour_price: 20, 
                        event: event)

      #Act
      login_as(user2)
      visit new_event_order_path(event)

      #Assert
      expect(page).to have_content('Você não tem acesso à essa página.')
    end
  end
end