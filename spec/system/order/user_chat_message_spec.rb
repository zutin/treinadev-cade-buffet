require 'rails_helper'

describe 'User uses the order message chat to talk to another user' do
  it 'can see order messages successfully' do
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
    order = Order.create!(desired_date: '2024-12-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, event: event, buffet: buffet, user: customer)

    #Act
    login_as(customer)
    visit order_path(order)

    #Assert
    expect(page).to have_content('Você pode iniciar uma conversa enviando uma mensagem.')
    expect(page).to have_field(placeholder: 'Escreva uma mensagem')
  end

  it 'can send a message succesfully' do
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
    order = Order.create!(desired_date: '2024-12-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, event: event, buffet: buffet, user: customer)

    #Act
    login_as(customer)
    visit order_path(order)
    fill_in placeholder: 'Escreva uma mensagem', with: 'Olá, tudo bem?'
    click_on 'Enviar'

    #Assert
    expect(page).to have_content('Olá, tudo bem?')
    expect(page).to have_content('Enviado')
  end

  it 'can read a new message successfully' do
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
    order = Order.create!(desired_date: '2024-12-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, event: event, buffet: buffet, user: customer)
    ChatMessage.create!(text: 'Olá cliente! Obrigado por nos contratar!', sender: owner, order: order)

    #Act
    login_as(customer)
    visit order_path(order)

    #Assert
    expect(page).to have_content('Olá cliente! Obrigado por nos contratar!')
    expect(page).to have_content('Visto')
  end

  it 'shouldnt be able to see another order messages' do
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
    first_order = Order.create!(desired_date: '2024-12-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, event: event, buffet: buffet, user: customer)
    second_order = Order.create!(desired_date: '2024-12-16', desired_address: 'Rua dos Bobos, 0', estimated_invitees: 20, event: event, buffet: buffet, user: customer)
    ChatMessage.create!(text: 'Olá cliente! Obrigado por nos contratar!', sender: owner, order: first_order, status: 'seen')
    ChatMessage.create!(text: 'Eu que agradeço!', sender: customer, order: first_order)
    ChatMessage.create!(text: 'Boa noite, estamos à disposição!', sender: owner, order: second_order)
    ChatMessage.create!(text: 'Qualquer coisa é só chamar', sender: owner, order: second_order)

    #Act
    login_as(customer)
    visit order_path(second_order)

    #Assert
    expect(page).not_to have_content('Olá cliente! Obrigado por nos contratar!')
    expect(page).not_to have_content('Eu que agradeço!')
    expect(page).to have_content('Boa noite, estamos à disposição!')
    expect(page).to have_content('Qualquer coisa é só chamar')
  end
end